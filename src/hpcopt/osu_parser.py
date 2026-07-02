from __future__ import annotations

from pathlib import Path

import pandas as pd


def parse_osu_text(text: str, kind: str, source: str = "stdin") -> pd.DataFrame:
    rows = []
    metric = "latency_us" if kind == "latency" else "bandwidth_mb_s"
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or line.lower().startswith("size"):
            continue
        parts = line.split()
        if len(parts) < 2:
            continue
        try:
            size = int(parts[0])
            value = float(parts[1])
        except ValueError:
            continue
        rows.append({"source": source, "message_size_bytes": size, metric: value})
    return pd.DataFrame(rows)


def parse_osu_path(path: str, kind: str) -> pd.DataFrame:
    target = Path(path)
    return parse_osu_text(target.read_text(errors="ignore"), kind=kind, source=target.name)
