from __future__ import annotations

import pandas as pd

from .utils import parse_duration_to_seconds, parse_slurm_mem_to_mb, safe_ratio


def load_sacct_csv(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, sep="|", dtype=str)
    df.columns = [c.strip() for c in df.columns]
    return df


def normalize_sacct(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    for col in ["ElapsedRaw", "TimelimitRaw", "AllocCPUS", "NNodes", "NTasks"]:
        if col in out.columns:
            out[col] = pd.to_numeric(out[col], errors="coerce").fillna(0)

    if "TotalCPU" in out.columns:
        out["TotalCPUSeconds"] = out["TotalCPU"].apply(parse_duration_to_seconds)
    else:
        out["TotalCPUSeconds"] = 0.0

    out["ElapsedSeconds"] = pd.to_numeric(out.get("ElapsedRaw", 0), errors="coerce").fillna(0)
    out["TimelimitSeconds"] = pd.to_numeric(out.get("TimelimitRaw", 0), errors="coerce").fillna(0) * 60
    out["AllocCPUS"] = pd.to_numeric(out.get("AllocCPUS", 0), errors="coerce").fillna(0)
    out["MaxRSSMB"] = out.get("MaxRSS", "0").apply(parse_slurm_mem_to_mb)
    out["ReqMemMB"] = out.get("ReqMem", "0").apply(parse_slurm_mem_to_mb)

    out["CPUCoreSecondsAllocated"] = out["ElapsedSeconds"] * out["AllocCPUS"]
    out["CPUEfficiency"] = out.apply(
        lambda r: safe_ratio(r["TotalCPUSeconds"], r["CPUCoreSecondsAllocated"]), axis=1
    )
    out["MemoryEfficiency"] = out.apply(lambda r: safe_ratio(r["MaxRSSMB"], r["ReqMemMB"]), axis=1)
    out["WalltimeEfficiency"] = out.apply(
        lambda r: safe_ratio(r["ElapsedSeconds"], r["TimelimitSeconds"]), axis=1
    )

    if {"Submit", "Start"}.issubset(out.columns):
        submit = pd.to_datetime(out["Submit"], errors="coerce")
        start = pd.to_datetime(out["Start"], errors="coerce")
        out["QueueWaitMinutes"] = ((start - submit).dt.total_seconds() / 60).fillna(0)
    else:
        out["QueueWaitMinutes"] = 0.0

    out["Finding"] = out.apply(classify_job, axis=1)
    return out


def classify_job(row: pd.Series) -> str:
    findings: list[str] = []
    state = str(row.get("State", "")).upper()
    if "FAILED" in state or "CANCELLED" in state or "TIMEOUT" in state:
        findings.append("job_state_review")
    if row.get("CPUEfficiency", 0) < 0.40 and row.get("AllocCPUS", 0) >= 8:
        findings.append("critical_low_cpu_efficiency")
    elif row.get("CPUEfficiency", 0) < 0.60 and row.get("AllocCPUS", 0) >= 8:
        findings.append("low_cpu_efficiency")
    if 0 < row.get("MemoryEfficiency", 0) < 0.25:
        findings.append("memory_over_requested")
    if 0 < row.get("WalltimeEfficiency", 0) < 0.35:
        findings.append("walltime_over_requested")
    if row.get("QueueWaitMinutes", 0) > 60:
        findings.append("long_queue_wait")
    return ", ".join(findings) if findings else "healthy_or_no_major_signal"


def summarize(df: pd.DataFrame) -> dict[str, float]:
    return {
        "jobs": float(len(df)),
        "avg_cpu_efficiency": float(df["CPUEfficiency"].mean() if len(df) else 0),
        "avg_memory_efficiency": float(df["MemoryEfficiency"].replace(0, pd.NA).dropna().mean() or 0),
        "avg_walltime_efficiency": float(df["WalltimeEfficiency"].replace(0, pd.NA).dropna().mean() or 0),
        "avg_queue_wait_minutes": float(df["QueueWaitMinutes"].mean() if len(df) else 0),
        "jobs_with_findings": float((df["Finding"] != "healthy_or_no_major_signal").sum()),
    }
