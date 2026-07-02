from __future__ import annotations

import pandas as pd

from .slurm_efficiency import summarize
from .utils import ensure_parent


def pct(value: float) -> str:
    return f"{value * 100:.1f}%"


def write_slurm_report(df: pd.DataFrame, output: str) -> None:
    summary = summarize(df)
    worst_cpu = df.sort_values("CPUEfficiency").head(10)
    worst_wall = df.sort_values("WalltimeEfficiency").head(10)
    findings = df["Finding"].value_counts().reset_index()
    findings.columns = ["Finding", "Count"]

    lines = [
        "# Slurm Scheduler Efficiency Report",
        "",
        "## Executive Summary",
        "",
        f"- Jobs analyzed: **{int(summary['jobs'])}**",
        f"- Average CPU efficiency: **{pct(summary['avg_cpu_efficiency'])}**",
        f"- Average memory efficiency: **{pct(summary['avg_memory_efficiency'])}**",
        f"- Average walltime efficiency: **{pct(summary['avg_walltime_efficiency'])}**",
        f"- Average queue wait: **{summary['avg_queue_wait_minutes']:.1f} minutes**",
        f"- Jobs with findings: **{int(summary['jobs_with_findings'])}**",
        "",
        "## Finding Distribution",
        "",
        findings.to_markdown(index=False),
        "",
        "## Lowest CPU Efficiency Jobs",
        "",
        worst_cpu[["JobIDRaw", "JobName", "Partition", "State", "AllocCPUS", "CPUEfficiency", "Finding"]].to_markdown(index=False),
        "",
        "## Lowest Walltime Efficiency Jobs",
        "",
        worst_wall[["JobIDRaw", "JobName", "Partition", "State", "ElapsedSeconds", "TimelimitSeconds", "WalltimeEfficiency", "Finding"]].to_markdown(index=False),
        "",
        "## Recommended Actions",
        "",
        "1. Review jobs below 40% CPU efficiency and validate MPI/OpenMP layout.",
        "2. Identify repeated memory over-requesting and publish workload-specific templates.",
        "3. Encourage realistic walltime requests to improve backfill opportunities.",
        "4. For long queue waits, compare partition pressure, QOS limits, and fairshare behavior.",
        "5. Re-run this report weekly and trend improvements over time.",
        "",
    ]
    ensure_parent(output).write_text("\n".join(lines))


def write_bottleneck_report(slurm_df: pd.DataFrame, ior_df: pd.DataFrame, output: str) -> None:
    signals = []
    low_cpu = int((slurm_df["CPUEfficiency"] < 0.40).sum()) if len(slurm_df) else 0
    mem_over = int(((slurm_df["MemoryEfficiency"] > 0) & (slurm_df["MemoryEfficiency"] < 0.25)).sum()) if len(slurm_df) else 0
    wall_over = int(((slurm_df["WalltimeEfficiency"] > 0) & (slurm_df["WalltimeEfficiency"] < 0.35)).sum()) if len(slurm_df) else 0

    if low_cpu:
        signals.append(("Compute underutilization", f"{low_cpu} jobs have CPU efficiency below 40%.", "Profile rank/thread placement, application imbalance, and I/O wait."))
    if mem_over:
        signals.append(("Memory over-requesting", f"{mem_over} jobs used less than 25% of requested memory.", "Tune memory requests and publish templates."))
    if wall_over:
        signals.append(("Walltime padding", f"{wall_over} jobs used less than 35% of requested walltime.", "Encourage realistic walltime to improve backfill."))

    if len(ior_df):
        write_df = ior_df[ior_df["operation"] == "write"]
        if len(write_df):
            best = write_df.sort_values("mean_mib_s", ascending=False).iloc[0]
            signals.append(("Best observed I/O write path", f"{best['source']} reached {best['mean_mib_s']:.1f} MiB/s mean write throughput.", "Use as a candidate layout for similar large-file workloads, then validate with application I/O."))

    if not signals:
        signals.append(("No major signal", "No threshold-based bottleneck was detected in the sample inputs.", "Collect a larger data window or lower thresholds if needed."))

    table = pd.DataFrame(signals, columns=["Signal", "Evidence", "Recommended action"])
    lines = [
        "# HPC Bottleneck Assessment",
        "",
        "## Prioritized Signals",
        "",
        table.to_markdown(index=False),
        "",
        "## Next Review Questions",
        "",
        "- Are low-efficiency jobs concentrated by user, application, partition, or module version?",
        "- Do I/O results change during peak hours versus quiet windows?",
        "- Are MPI latency spikes correlated with node placement?",
        "- Can templates reduce repeated over-allocation patterns?",
        "",
    ]
    ensure_parent(output).write_text("\n".join(lines))
