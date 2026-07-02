from __future__ import annotations

import re
from pathlib import Path

import pandas as pd


SUMMARY_PATTERN = re.compile(
    r"^(?P<operation>read|write)\s+"
    r"(?P<max_mib>[0-9.]+)\s+"
    r"(?P<min_mib>[0-9.]+)\s+"
    r"(?P<mean_mib>[0-9.]+)\s+"
    r"(?P<stddev>[0-9.]+)",
    re.IGNORECASE,
)


def parse_ior_text(text: str, source: str = "stdin") -> pd.DataFrame:
    rows = []
    api = None
    block_size = None
    transfer_size = None

    for line in text.splitlines():
        if "api" in line.lower() and ":" in line:
            maybe = line.split(":", 1)[1].strip()
            if maybe:
                api = maybe.split()[0]
        if "blockSize" in line:
            block_size = line.split("=", 1)[-1].strip().split()[0]
        if "transferSize" in line:
            transfer_size = line.split("=", 1)[-1].strip().split()[0]

        match = SUMMARY_PATTERN.match(line.strip())
        if match:
            data = match.groupdict()
            rows.append(
                {
                    "source": source,
                    "api": api,
                    "block_size": block_size,
                    "transfer_size": transfer_size,
                    "operation": data["operation"].lower(),
                    "max_mib_s": float(data["max_mib"]),
                    "min_mib_s": float(data["min_mib"]),
                    "mean_mib_s": float(data["mean_mib"]),
                    "stddev": float(data["stddev"]),
                }
            )
    return pd.DataFrame(rows)


def parse_ior_path(path: str) -> pd.DataFrame:
    target = Path(path)
    frames = []
    if target.is_dir():
        files = sorted(target.glob("*.out"))
    else:
        files = [target]
    for file in files:
        frames.append(parse_ior_text(file.read_text(errors="ignore"), source=file.name))
    return pd.concat(frames, ignore_index=True) if frames else pd.DataFrame()
