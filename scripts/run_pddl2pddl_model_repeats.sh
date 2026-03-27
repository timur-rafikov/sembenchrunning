#!/usr/bin/env bash
# Прогон PDDL→PDDL (finalset) для Qwen 3.5 Flash и DeepSeek V3.2 по NUM_RUNS раз.
# Для каждой модели:
#   results_<short>_pddl2pddl/finalset_full_<K>/  — run JSON, metrics.jsonl, *.val.txt, console.log
#   results_<short>_pddl2pddl/metricstext/run<K>   — фрагмент консоли с Coverage + Aggregate (как у grok)
#
# Требования: OPENROUTER_API_KEY, запуск из корня репо (или задайте SEMBENCH_ROOT).
#
# Переменные окружения (опционально):
#   SEMBENCH_ROOT      — корень sembenchrunning (по умолчанию: родитель scripts/)
#   DATASET_DIR        — по умолчанию data/finalset
#   VAL_BINARY         — по умолчанию /mnt/d/work/VAL/build/bin/validate
#   CONFIG             — по умолчанию models_config.yaml
#   NUM_RUNS           — по умолчанию 5
#   EXTRA_ARGS         — доп. аргументы к run_benchmark.py (строка)
#
# Пример:
#   chmod +x scripts/run_pddl2pddl_model_repeats.sh
#   ./scripts/run_pddl2pddl_model_repeats.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="${SEMBENCH_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
cd "$REPO"

DATASET_DIR="${DATASET_DIR:-data/finalset}"
VAL_BINARY="${VAL_BINARY:-/mnt/d/work/VAL/build/bin/validate}"
CONFIG="${CONFIG:-models_config.yaml}"
NUM_RUNS="${NUM_RUNS:-5}"
PYTHON="${PYTHON:-python3}"
# set -u: пустая строка по умолчанию, иначе «unbound variable» при $EXTRA_ARGS
EXTRA_ARGS="${EXTRA_ARGS:-}"

if [[ ! -f "$CONFIG" ]]; then
  echo "Config not found: $REPO/$CONFIG" >&2
  exit 1
fi
if [[ ! -d "$DATASET_DIR" ]]; then
  echo "Dataset dir not found: $REPO/$DATASET_DIR" >&2
  exit 1
fi

# Ключ: строка --model из models_config.yaml; значение: короткое имя для папки results_<short>_pddl2pddl
declare -A SHORT_BY_MODEL=(
  ["qwen/qwen3.5-flash-02-23"]="qwen35flash"
  ["deepseek/deepseek-v3.2"]="deepseekv32"
  ["xiaomi/mimo-v2-flash"]="mimo2flash"
  ["google/gemini-3.1-flash-lite-preview"]="gemini31"
  ["x-ai/grok-4.1-fast"]="grok4fast"
)

MODELS=(
  "x-ai/grok-4.1-fast"
)

run_one() {
  local model="$1"
  local short="$2"
  local k="$3"
  local results_base="results_${short}_pddl2pddl"
  local out_dir="${results_base}/finalset_full_${k}"
  local metrics_dir="${results_base}/metricstext"
  local console_log="${out_dir}/console.log"
  local metrics_out="${metrics_dir}/run${k}"

  mkdir -p "$out_dir" "$metrics_dir"

  echo "========================================"
  echo "Model: $model"
  echo "Output: $out_dir"
  echo "Metrics extract -> $metrics_out"
  echo "========================================"

  set +e
  # shellcheck disable=SC2086
  "$PYTHON" run_benchmark.py \
    --pddl2pddl \
    --dataset-dir "$DATASET_DIR" \
    --output-dir "$out_dir" \
    --model "$model" \
    --val-binary "$VAL_BINARY" \
    --debug \
    --config "$CONFIG" \
    $EXTRA_ARGS \
    2>&1 | tee "$console_log"
  local rc="${PIPESTATUS[0]}"
  set -e

  if awk '/^\[sembenchrunning\] Coverage by model:/,0' "$console_log" > "$metrics_out"; then
    :
  fi
  if [[ ! -s "$metrics_out" ]]; then
    echo "WARNING: no metrics block in log (empty or run failed before metrics): $metrics_out" >&2
  fi
  if [[ "$rc" -ne 0 ]]; then
    echo "WARNING: run_benchmark exited with $rc for $model finalset_full_$k" >&2
  fi
}

for model in "${MODELS[@]}"; do
  short="${SHORT_BY_MODEL[$model]:-}"
  if [[ -z "$short" ]]; then
    echo "No short name mapping for model: $model" >&2
    exit 1
  fi
  for ((k = 1; k <= NUM_RUNS; k++)); do
    run_one "$model" "$short" "$k"
  done
done

echo "All requested runs finished."
