from __future__ import annotations

import re
from pathlib import Path


def ensure_parent(path: str | Path) -> Path:
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    return target


def parse_slurm_mem_to_mb(value: str | float | int | None) -> float:
    """Parse Slurm memory values like 64000M, 120G, 4Gn, 1000Mc into MB."""
    if value is None:
        return 0.0
    text = str(value).strip()
    if not text or text.lower() in {"nan", "unknown", "none"}:
        return 0.0

    # Slurm may suffix memory with c/n for per-cpu/per-node. We keep the numeric MB equivalent.
    match = re.match(r"(?P<num>[0-9.]+)\s*(?P<unit>[KMGTP]?)(?P<scope>[cnCN]?)", text)
    if not match:
        return 0.0
    number = float(match.group("num"))
    unit = match.group("unit").upper()
    multiplier = {
        "": 1 / 1024,
        "K": 1 / 1024,
        "M": 1,
        "G": 1024,
        "T": 1024 * 1024,
        "P": 1024 * 1024 * 1024,
    }.get(unit, 1)
    return number * multiplier


def parse_duration_to_seconds(value: str | float | int | None) -> float:
    """Parse Slurm-like duration strings into seconds.

    Handles raw seconds, MM:SS, HH:MM:SS, D-HH:MM:SS, and simple numeric strings.
    """
    if value is None:
        return 0.0
    if isinstance(value, (int, float)):
        return float(value)
    text = str(value).strip()
    if not text or text.lower() in {"nan", "unknown", "none"}:
        return 0.0
    if text.isdigit():
        return float(text)

    days = 0
    if "-" in text:
        day_part, text = text.split("-", 1)
        days = int(day_part)

    parts = [int(p) for p in text.split(":")]
    if len(parts) == 3:
        hours, minutes, seconds = parts
    elif len(parts) == 2:
        hours = 0
        minutes, seconds = parts
    elif len(parts) == 1:
        hours = 0
        minutes = 0
        seconds = parts[0]
    else:
        return 0.0
    return float(days * 86400 + hours * 3600 + minutes * 60 + seconds)


def safe_ratio(numerator: float, denominator: float) -> float:
    if denominator <= 0:
        return 0.0
    return max(0.0, min(float(numerator) / float(denominator), 999.0))
