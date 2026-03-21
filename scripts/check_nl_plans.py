#!/usr/bin/env python3
"""Проверяет наличие NL-планов в run JSON (content / reasoning)."""
import json
import sys
from pathlib import Path

def main():
    out_dir = Path(__file__).resolve().parent.parent / "runs" / "batch_samples"
    if not out_dir.exists():
        print(f"Directory not found: {out_dir}")
        return
    files = sorted(out_dir.glob("*__openai_gpt-5-mini.json"))
    if not files:
        print("No run files found.")
        return

    total = len(files)
    has_error_all = 0
    has_content_all = 0
    has_reasoning_all = 0
    samples = []

    for path in files:
        try:
            d = json.loads(path.read_text(encoding="utf-8"))
        except Exception as e:
            print(f"{path.name}: read error {e}")
            continue
        if "error" in d:
            has_error_all += 1
            continue
        msg = d.get("openrouter_response", {}).get("choices", [{}])[0].get("message", {})
        content = (msg.get("content") or "").strip()
        reasoning = (msg.get("reasoning") or "").strip()
        c_len = len(content)
        r_len = len(reasoning)
        if c_len > 0:
            has_content_all += 1
            if len(samples) < 5:
                samples.append((path.name, "content", c_len, (content[:120] + "...")))
        elif r_len > 0:
            has_reasoning_all += 1
            if len(samples) < 5:
                samples.append((path.name, "reasoning", r_len, (reasoning[:120] + "...")))
        else:
            if len(samples) < 5:
                samples.append((path.name, "none", 0, ""))

    print(f"Total run files: {total}")
    print(f"  with error: {has_error_all}")
    print(f"  with message.content (NL plan): {has_content_all}")
    print(f"  with message.reasoning only (no content): {has_reasoning_all}")
    print()
    if samples:
        print("Sample previews:")
        for name, kind, length, preview in samples:
            print(f"  {name}: {kind} len={length}")
            if preview:
                print(f"    {preview!r}")


if __name__ == "__main__":
    main()
