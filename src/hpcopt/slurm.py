from __future__ import annotations
import csv
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

@dataclass
class Job:
    job_id: str
    state: str
    alloc_cpus: int
    elapsed_seconds: int
    total_cpu_seconds: int
    req_mem_mb: float
    max_rss_mb: float
    requested_wall_seconds: int


def _pct(n: float, d: float) -> float:
    return 0.0 if d <= 0 else round(100.0 * n / d, 1)


def load_jobs(path: str | Path) -> list[Job]:
    jobs: list[Job] = []
    with open(path, newline="", encoding="utf-8") as f:
        for r in csv.DictReader(f):
            jobs.append(Job(
                job_id=r["job_id"],
                state=r["state"],
                alloc_cpus=int(r["alloc_cpus"]),
                elapsed_seconds=int(r["elapsed_seconds"]),
                total_cpu_seconds=int(r["total_cpu_seconds"]),
                req_mem_mb=float(r["req_mem_mb"]),
                max_rss_mb=float(r["max_rss_mb"]),
                requested_wall_seconds=int(r["requested_wall_seconds"]),
            ))
    return jobs


def classify(job: Job) -> dict[str, object]:
    cpu_capacity = job.alloc_cpus * job.elapsed_seconds
    cpu_eff = _pct(job.total_cpu_seconds, cpu_capacity)
    mem_eff = _pct(job.max_rss_mb, job.req_mem_mb)
    wall_eff = _pct(job.elapsed_seconds, job.requested_wall_seconds)
    findings: list[str] = []
    if cpu_eff < 50:
        findings.append("low_cpu_efficiency")
    if mem_eff < 35:
        findings.append("memory_overrequest")
    if wall_eff < 25:
        findings.append("walltime_padding")
    return {"cpu_efficiency_pct": cpu_eff, "memory_efficiency_pct": mem_eff, "walltime_efficiency_pct": wall_eff, "findings": findings}


def render_report(jobs: Iterable[Job]) -> str:
    rows = []
    findings_count: dict[str, int] = {}
    for j in jobs:
        m = classify(j)
        for x in m["findings"]:
            findings_count[x] = findings_count.get(x, 0) + 1
        rows.append((j, m))
    out = ["# Slurm Efficiency Report", "", "| Job | State | CPU eff. | Memory eff. | Walltime eff. | Findings |", "|---|---:|---:|---:|---:|---|"]
    for j, m in rows:
        out.append(f"| {j.job_id} | {j.state} | {m['cpu_efficiency_pct']}% | {m['memory_efficiency_pct']}% | {m['walltime_efficiency_pct']}% | {', '.join(m['findings']) or 'none'} |")
    out.extend(["", "## Operational interpretation", ""])
    if findings_count:
        for k, v in sorted(findings_count.items()):
            out.append(f"- **{k}**: {v} job(s)")
    else:
        out.append("- No major efficiency flags in the sample.")
    out.extend(["", "Use these findings to start a researcher conversation before changing limits or QOS policy. Scheduler efficiency should be interpreted with workload science, scaling behavior and turnaround objectives in mind."])
    return "\n".join(out) + "\n"
