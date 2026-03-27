import json
import sys
from pathlib import Path

p = Path(__file__).resolve().parent / "visual.ipynb"
if not p.exists():
    print("missing", p, file=sys.stderr)
    sys.exit(1)
nb = json.loads(p.read_text(encoding="utf-8"))
for i, c in enumerate(nb.get("cells", [])):
    src = "".join(c.get("source", []))
    print(f"=== CELL {i} ({c.get('cell_type')}) ===")
    print(src[:2000] + ("..." if len(src) > 2000 else ""))
    for o in c.get("outputs", []):
        if o.get("output_type") == "error":
            print("ERROR:", o.get("ename"), o.get("evalue"))
            for line in o.get("traceback") or []:
                print(line)
        elif o.get("output_type") == "stream":
            t = o.get("text", "")
            if isinstance(t, list):
                t = "".join(t)
            if "Error" in t or "Traceback" in t or "Warning" in t:
                print("STREAM:", t[:1500])
    print()
