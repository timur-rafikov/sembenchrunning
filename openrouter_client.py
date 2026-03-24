import json
import os
from dataclasses import dataclass
from typing import Any, Dict, Optional

import httpx
import yaml


@dataclass
class OpenRouterSettings:
  api_base: str
  api_key_env: str
  http_referer: Optional[str]
  x_title: Optional[str]
  timeout_seconds: int
  max_concurrent_requests: int
  max_retries: int
  retry_backoff_seconds: float


class OpenRouterAPIError(Exception):
  """Ошибка при вызове OpenRouter с дополнительной диагностикой."""

  def __init__(
    self,
    status_code: int | None,
    message: str,
    error_body: Any | None = None,
  ) -> None:
    super().__init__(message)
    self.status_code = status_code
    self.error_body = error_body


class InsufficientBalanceError(OpenRouterAPIError):
  """Недостаточно средств / кредитов на OpenRouter (HTTP 402)."""


def extract_openrouter_usage_from_error_body(error_body: Any) -> Optional[Dict[str, Any]]:
  """
  Пытается извлечь объект usage из тела ошибки OpenRouter (иногда usage всё же приходит).
  Рекурсивно смотрит верхний уровень, error.usage, вложенные data/response.
  """
  if error_body is None:
    return None
  if isinstance(error_body, dict):
    u = error_body.get("usage")
    if isinstance(u, dict) and u:
      return dict(u)
    err = error_body.get("error")
    if isinstance(err, dict):
      u2 = err.get("usage")
      if isinstance(u2, dict) and u2:
        return dict(u2)
    for k in ("data", "response", "body"):
      sub = error_body.get(k)
      if isinstance(sub, dict):
        got = extract_openrouter_usage_from_error_body(sub)
        if got:
          return got
  return None


def _extract_choice_error_info(response_json: Any) -> Optional[Dict[str, Any]]:
  """Извлекает ошибку провайдера из envelope OpenRouter choices[0].error."""
  if not isinstance(response_json, dict):
    return None
  choices = response_json.get("choices")
  if not isinstance(choices, list) or not choices:
    return None
  choice0 = choices[0]
  if not isinstance(choice0, dict):
    return None
  err = choice0.get("error")
  if not isinstance(err, dict) or not err:
    return None
  return {
    "code": err.get("code"),
    "message": err.get("message") or str(err),
    "metadata": err.get("metadata"),
    "raw": err,
  }


def _is_transient_error_info(error_info: Dict[str, Any]) -> bool:
  code = error_info.get("code")
  try:
    code_int = int(code)
  except (TypeError, ValueError):
    code_int = None
  if code_int == 429 or (code_int is not None and code_int >= 500):
    return True
  metadata = error_info.get("metadata")
  if isinstance(metadata, dict):
    err_type = str(metadata.get("error_type") or "").lower()
    if err_type in {"provider_unavailable", "rate_limited", "timeout"}:
      return True
  message = str(error_info.get("message") or "").lower()
  return any(token in message for token in ("temporar", "timeout", "network connection lost", "provider unavailable"))


def load_config(path: str) -> Dict[str, Any]:
  """Загрузка YAML‑конфига моделей и настроек OpenRouter."""
  with open(path, "r", encoding="utf-8") as f:
    data = yaml.safe_load(f)
  if not isinstance(data, dict):
    raise ValueError("models_config.yaml must contain a top-level mapping")
  return data


def load_openrouter_settings(cfg: Dict[str, Any]) -> OpenRouterSettings:
  o = cfg.get("openrouter") or {}
  return OpenRouterSettings(
    api_base=o.get("api_base", "https://openrouter.ai/api/v1/chat/completions"),
    api_key_env=o.get("api_key_env", "OPENROUTER_API_KEY"),
    http_referer=o.get("http_referer"),
    x_title=o.get("x_title", "sembenchrunning"),
    timeout_seconds=int(o.get("timeout_seconds", 600)),
    max_concurrent_requests=int(o.get("max_concurrent_requests", 16)),
    max_retries=int(o.get("max_retries", 3)),
    retry_backoff_seconds=float(o.get("retry_backoff_seconds", 2.0)),
  )


def chat_completion_body_model_fields(model_cfg: Dict[str, Any]) -> Dict[str, Any]:
  """
  Поля тела chat/completions из model_cfg (без messages) — то же, что уходит в HTTP из generate_plan.
  Используется и для запроса, и для openrouter_request в логах.
  """
  out: Dict[str, Any] = {"model": model_cfg["model"]}
  max_tokens = model_cfg.get("max_output_tokens")
  if max_tokens is not None:
    mt = int(max_tokens)
    out["max_tokens"] = mt
    out["max_output_tokens"] = mt
  temperature = model_cfg.get("temperature")
  if temperature is not None:
    out["temperature"] = float(temperature)
  reasoning = model_cfg.get("reasoning")
  if reasoning is not None:
    if isinstance(reasoning, str):
      out["reasoning"] = {"effort": reasoning}
    else:
      out["reasoning"] = reasoning
  return out


def openrouter_request_snapshot_from_model_cfg(model_cfg: Dict[str, Any]) -> Dict[str, Any]:
  """
  Сериализуемый снимок параметров, уходящих в тело chat/completions (для логов run JSON).
  Совпадает с фактическим телом запроса (кроме messages и extra_params). Без секретов.
  """
  return dict(chat_completion_body_model_fields(model_cfg))


def get_model_config(cfg: Dict[str, Any], model_name: str) -> Dict[str, Any]:
  models = cfg.get("models") or {}
  if model_name not in models:
    available = ", ".join(sorted(models.keys()))
    raise KeyError(
      f"Model '{model_name}' not found in models_config.yaml. "
      f"Available models: {available}"
    )
  model_cfg = models[model_name] or {}
  if "model" not in model_cfg:
    raise KeyError(f"Model '{model_name}' must define 'model' (OpenRouter id).")
  return model_cfg


class OpenRouterClient:
  """Клиент для отправки запросов в OpenRouter."""

  def __init__(self, settings: OpenRouterSettings):
    self.settings = settings
    api_key = os.getenv(settings.api_key_env)
    if not api_key:
      raise RuntimeError(
        f"OpenRouter API key not found. "
        f"Set environment variable {settings.api_key_env}."
      )
    self._api_key = api_key
    self._client: Optional[httpx.AsyncClient] = None

  async def __aenter__(self) -> "OpenRouterClient":
    # Большой таймаут, чтобы модели могли "долго думать".
    self._client = httpx.AsyncClient(timeout=self.settings.timeout_seconds)
    return self

  async def __aexit__(self, exc_type, exc, tb) -> None:
    if self._client is not None:
      await self._client.aclose()
      self._client = None

  @property
  def client(self) -> httpx.AsyncClient:
    if self._client is None:
      raise RuntimeError("HTTP client is not initialized. Use 'async with OpenRouterClient(...)'.")
    return self._client

  def _build_headers(self) -> Dict[str, str]:
    headers: Dict[str, str] = {
      "Authorization": f"Bearer {self._api_key}",
      "Content-Type": "application/json",
    }
    if self.settings.http_referer:
      headers["HTTP-Referer"] = self.settings.http_referer
    if self.settings.x_title:
      headers["X-Title"] = self.settings.x_title
    return headers

  async def generate_plan(
    self,
    model_cfg: Dict[str, Any],
    prompt: str,
    extra_params: Optional[Dict[str, Any]] = None,
  ) -> Dict[str, Any]:
    """
    Отправляет промпт (включая PDDL‑домен и проблему) в указанную модель
    и возвращает JSON‑ответ OpenRouter.
    """
    body: Dict[str, Any] = {
      "messages": [
        {
          "role": "user",
          "content": prompt,
        }
      ],
    }
    body.update(chat_completion_body_model_fields(model_cfg))

    if extra_params:
      body.update(extra_params)

    headers = self._build_headers()

    last_exc: Optional[BaseException] = None
    for attempt in range(self.settings.max_retries + 1):
      try:
        response = await self.client.post(
          self.settings.api_base,
          headers=headers,
          content=json.dumps(body),
        )

        # Ошибки, на которые стоит попробовать ретрай.
        if response.status_code >= 500 or response.status_code == 429:
          error_body = self._safe_json(response)
          last_exc = OpenRouterAPIError(
            status_code=response.status_code,
            message=f"OpenRouter transient error {response.status_code}",
            error_body=error_body,
          )
        else:
          # Любые "нормальные" ошибки и успешный ответ обрабатываем отдельно.
          if 200 <= response.status_code < 300:
            response_json = response.json()
            choice_error = _extract_choice_error_info(response_json)
            if choice_error is None:
              return response_json

            code = choice_error.get("code")
            try:
              code_int = int(code)
            except (TypeError, ValueError):
              code_int = None
            if code_int == 402 or "insufficient" in str(choice_error.get("message") or "").lower():
              raise InsufficientBalanceError(
                status_code=code_int,
                message=str(choice_error.get("message") or "Insufficient OpenRouter credits."),
                error_body=response_json,
              )
            if _is_transient_error_info(choice_error):
              last_exc = OpenRouterAPIError(
                status_code=code_int,
                message=str(choice_error.get("message") or "OpenRouter transient provider error"),
                error_body=response_json,
              )
            else:
              raise OpenRouterAPIError(
                status_code=code_int,
                message=str(choice_error.get("message") or "OpenRouter provider error"),
                error_body=response_json,
              )
          else:
            error_body = self._safe_json(response)
            error_info = self._extract_error_info(error_body)

            # Специальная обработка 402 — недостаточно кредитов.
            if response.status_code == 402 or (
              error_info.get("code") == 402
              or "insufficient" in error_info.get("message", "").lower()
            ):
              raise InsufficientBalanceError(
                status_code=response.status_code,
                message=error_info.get("message", "Insufficient OpenRouter credits."),
                error_body=error_body,
              )

            # Остальные ошибки — как общие API‑ошибки.
            raise OpenRouterAPIError(
              status_code=response.status_code,
              message=error_info.get("message", f"OpenRouter error {response.status_code}"),
              error_body=error_body,
            )

      except (httpx.RequestError, httpx.HTTPStatusError) as exc:
        last_exc = exc

      # Если не последняя попытка — подождём и попробуем ещё раз.
      if attempt < self.settings.max_retries:
        await self._sleep_backoff(attempt)

    # Если добрались сюда — все попытки не удались.
    if last_exc is None:
      raise OpenRouterAPIError(
        status_code=None,
        message="Unknown error when calling OpenRouter.",
        error_body=None,
      )
    if isinstance(last_exc, OpenRouterAPIError):
      raise last_exc
    raise OpenRouterAPIError(
      status_code=None,
      message=str(last_exc),
      error_body=None,
    )

  def _safe_json(self, response: httpx.Response) -> Any:
    try:
      return response.json()
    except ValueError:
      return {"raw": response.text}

  def _extract_error_info(self, error_body: Any) -> Dict[str, Any]:
    """
    Приводим тело ошибки к унифицированному виду:
    code, message, metadata (если есть).
    """
    if isinstance(error_body, dict) and isinstance(error_body.get("error"), dict):
      err = error_body["error"]
      return {
        "code": err.get("code"),
        "message": err.get("message") or str(err),
        "metadata": err.get("metadata"),
      }
    if isinstance(error_body, dict):
      return {
        "code": error_body.get("code"),
        "message": error_body.get("message") or str(error_body),
        "metadata": error_body.get("metadata"),
      }
    # На крайний случай.
    return {"code": None, "message": str(error_body), "metadata": None}

  async def _sleep_backoff(self, attempt: int) -> None:
    # Простая экспоненциальная задержка: base * 2^attempt
    import asyncio

    delay = self.settings.retry_backoff_seconds * (2**attempt)
    await asyncio.sleep(delay)

