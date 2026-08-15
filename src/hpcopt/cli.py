from __future__ import annotations
import argparse
from pathlib import Path
from .slurm import load_jobs, render_report


def main() -> int:
    p = argparse.ArgumentParser(prog="hpcopt")
    sub = p.add_subparsers(dest="cmd", required=True)
    sr = sub.add_parser("slurm-report")
    sr.add_argument("--input", required=True)
    sr.add_argument("--output", required=True)
    args = p.parse_args()
    if args.cmd == "slurm-report":
        text = render_report(load_jobs(args.input))
        out = Path(args.output)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text, encoding="utf-8")
        print(out)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
