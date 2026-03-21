"""
Просмотр полей content/reasoning в run JSON от MINIMAX:
- где лежит план (content vs reasoning)
- есть ли в начале/конце посторонний текст (преамбула, пояснения)
"""
import json
import re
from pathlib import Path

RUNS = Path(__file__).resolve().parent.parent / "runs" / "batch_samples"
# Только run-файлы minimax, без debug
PATTERN = "*minimax_minimax-m2.5.json"
SKIP_DEBUG = "__nl2pddl_debug"

def get_message(data):
    try:
        return data.get("openrouter_response", {}).get("choices", [{}])[0].get("message", {})
    except (IndexError, KeyError, TypeError):
        return {}

def main():
    files = sorted(f for f in RUNS.glob(PATTERN) if SKIP_DEBUG not in f.name and f.is_file())
    print(f"Found {len(files)} minimax run files (no debug)\n")

    # Типичные фразы не-плана в начале
    intro_patterns = [
        r"^(here is|here'?s|the plan is|plan:?\s*$|below is|as follows:?|see below|step \d+\.?\s*[-:]?\s*)",
        r"^(i (?:will |have )?|we (?:will |have )?|let me |sure\.?\s*)",
        r"^(\*\*|#+)\s*",  # markdown headers
        r"^(step|action)\s*\d+\s*[.:]",
    ]
    intro_re = re.compile("|".join(intro_patterns), re.I)

    content_used = 0
    reasoning_used = 0
    content_has_intro = []
    reasoning_has_intro = []
    content_preview = []
    reasoning_preview = []

    for path in files[:60]:  # первые 60
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except Exception as e:
            print(f"  {path.name}: read error {e}")
            continue
        msg = get_message(data)
        content = (msg.get("content") or "").strip()
        reasoning = (msg.get("reasoning") or "").strip()

        # Что бы взял скрипт (как _get_nl_plan_from_run)
        chosen = content if content else reasoning
        source = "content" if content else "reasoning"
        if source == "content":
            content_used += 1
        else:
            reasoning_used += 1

        first_line = chosen.split("\n")[0].strip() if chosen else ""
        first_200 = (chosen[:200] + "..." if len(chosen) > 200 else chosen).replace("\n", " ")

        if intro_re.match(first_line):
            if source == "content":
                content_has_intro.append((path.name, first_line[:80]))
            else:
                reasoning_has_intro.append((path.name, first_line[:80]))

        content_preview.append((path.name, "content" if content else "-", len(content), first_200[:120]))
        if reasoning and not content:
            reasoning_preview.append((path.name, "reasoning", len(reasoning), first_200[:120]))

    print("--- Source: content vs reasoning ---")
    print(f"  Plan taken from content: {content_used}")
    print(f"  Plan taken from reasoning (content empty): {reasoning_used}")

    print("\n--- Samples where first line looks like intro (not plan step) ---")
    for name, line in (content_has_intro + reasoning_has_intro)[:25]:
        print(f"  {name}")
        print(f"    first line: {line!r}")

    print("\n--- Preview: first ~120 chars of chosen plan (first 25 files) ---")
    for name, src, length, pre in content_preview[:25]:
        print(f"  [{src}] len={length} {name}")
        print(f"    {pre!r}")

    if reasoning_preview:
        print("\n--- Files where plan is in reasoning only (first 15) ---")
        for name, src, length, pre in reasoning_preview[:15]:
            print(f"  {name} len={length}")
            print(f"    {pre!r}")

if __name__ == "__main__":
    main()
