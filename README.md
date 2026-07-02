# HPC Workload Optimization & Benchmarking

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue)](#)
[![Slurm](https://img.shields.io/badge/Scheduler-Slurm-green)](#)
[![MPI](https://img.shields.io/badge/MPI-OpenMPI%20%7C%20MPICH-orange)](#)
[![Lustre](https://img.shields.io/badge/Filesystem-Lustre-purple)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Repository:** `github.com/m-aboud/hpc-workload-optimization`

Elite-level, portfolio-ready HPC operations project demonstrating **Slurm scheduler analysis**, **Lustre stripe optimization**, **MPI profiling**, and **parallel I/O benchmarking** using IOR and OSU Micro-Benchmarks.

This project is designed to show hands-on capability for scientific HPC environments, including job efficiency analytics, workload bottleneck detection, benchmark automation, and evidence-based tuning recommendations.

---

## What This Project Demonstrates

| Capability | What is included |
|---|---|
| Slurm workload analysis | `sacct` export parser, CPU/memory efficiency scoring, queue wait analysis, job bottleneck classification |
| Scheduler optimization | QOS/partition review checklist, backfill-aware recommendations, walltime accuracy analysis |
| Lustre optimization | Stripe count/stripe size sweep scripts, `lfs setstripe` automation, file-layout verification |
| MPI profiling | `mpiP`, `perf`, and `srun` template for MPI application profiling |
| Parallel I/O benchmarking | IOR test matrix across storage tiers, transfer-size sweep, POSIX vs MPI-IO mode support |
| MPI network microbenchmarks | OSU latency and bandwidth benchmark wrappers |
| Reporting | Markdown and CSV outputs suitable for GitHub, audit evidence, and operations handover |

---

## Architecture

```text
HPC users / workloads
        |
        v
Slurm scheduler  ---> sacct/squeue/sinfo exports ---> Python analytics engine
        |                                             |
        |                                             v
        |                                      bottleneck report
        v
Compute nodes + MPI runtime ---> OSU / mpiP / perf ---> communication profile
        |
        v
Lustre / scratch / project tiers ---> IOR + lfs setstripe ---> I/O tuning matrix
```

---

## Repository Structure

```text
.
├── configs/                 # Example cluster and benchmark configuration
├── docs/                    # Methodology, tuning playbooks, interpretation guide
├── examples/                # Sanitized sample inputs for local testing
│   └── sample-reports/      # Pre-rendered example outputs (committed for browsing)
├── reports/                 # Generated at runtime by `make demo` (gitignored)
├── scripts/                 # Bash automation for Slurm, Lustre, IOR, OSU, MPI profiling
├── slurm/templates/         # sbatch templates ready for cluster customization
├── src/hpcopt/              # Python CLI and analytics modules
├── tests/                   # Parser/unit tests
├── Makefile                 # One-command local demo workflow
└── pyproject.toml           # Python package metadata
```

---

## Quick Start: Local Demo Mode

This mode runs against bundled sample data, so it works from a laptop without Slurm/Lustre.

```bash
git clone https://github.com/m-aboud/hpc-workload-optimization.git
cd hpc-workload-optimization
python -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
make demo
```

Expected outputs:

```text
reports/slurm_efficiency_report.md
reports/ior_summary.csv
reports/osu_latency.csv
reports/osu_bandwidth.csv
reports/bottleneck_assessment.md
```

> To preview these outputs without running anything, see [`examples/sample-reports/`](examples/sample-reports/).

---

## Cluster Mode

> Customize `configs/cluster.example.yaml` and the `slurm/templates/*.sbatch` files before running on a production cluster.

### 1. Collect scheduler efficiency metrics

```bash
bash scripts/collect_slurm_metrics.sh --days 14 --output reports/sacct_last14d.csv
hpcopt slurm-report --input reports/sacct_last14d.csv --output reports/slurm_efficiency_report.md
```

### 2. Run IOR sweep against Lustre scratch

```bash
bash scripts/run_ior_sweep.sh \
  --target /lustre/scratch/$USER/hpcopt-ior \
  --nodes 2 \
  --ntasks-per-node 32 \
  --output reports/ior_raw

hpcopt parse-ior --input reports/ior_raw --output reports/ior_summary.csv
```

### 3. Run Lustre stripe sweep

```bash
bash scripts/lustre_stripe_sweep.sh \
  --target /lustre/scratch/$USER/hpcopt-stripe \
  --stripe-counts "1 2 4 8 16" \
  --stripe-sizes "1m 4m 16m" \
  --nodes 2 \
  --ntasks-per-node 32
```

### 4. Run MPI latency/bandwidth benchmarks

```bash
bash scripts/run_osu_latency_bw.sh --nodes 2 --ntasks-per-node 1 --output reports/osu_raw
hpcopt parse-osu --input reports/osu_raw/osu_latency.out --kind latency --output reports/osu_latency.csv
hpcopt parse-osu --input reports/osu_raw/osu_bw.out --kind bandwidth --output reports/osu_bandwidth.csv
```

---

## Example Findings Produced by the Toolkit

The included sample dataset produces findings like:

- **Low CPU efficiency:** MPI job allocated 512 CPU cores but used only ~42% of expected CPU time.
- **Memory over-requesting:** ETL job requested 1 TB RAM and used ~180 GB, reducing cluster schedulability.
- **Walltime padding:** Multiple jobs requested 24 hours and finished in under 2 hours, weakening backfill efficiency.
- **Lustre stripe mismatch:** Large-file write throughput improved when stripe count increased from 1 to 8, but plateaued beyond 8.
- **MPI communication issue:** Latency spike above the expected baseline suggests node placement or fabric contention should be reviewed.

---

## Core CLI Commands

```bash
hpcopt slurm-report --input examples/sample_sacct.csv --output reports/slurm_efficiency_report.md
hpcopt parse-ior --input examples/sample_ior.txt --output reports/ior_summary.csv
hpcopt parse-osu --input examples/sample_osu_latency.txt --kind latency --output reports/osu_latency.csv
hpcopt parse-osu --input examples/sample_osu_bw.txt --kind bandwidth --output reports/osu_bandwidth.csv
hpcopt bottlenecks --sacct examples/sample_sacct.csv --ior examples/sample_ior.txt --output reports/bottleneck_assessment.md
```

---

## Production Safety Notes

- Run benchmarks only on approved partitions or during agreed maintenance windows.
- Avoid running IOR against shared project storage without approval.
- Keep test files isolated under a user-owned scratch directory.
- Always tag benchmark jobs with a clear Slurm job name such as `hpcopt_ior_sweep`.
- Do not publish production cluster names, user names, project IDs, or raw job records without sanitization.

---

## Suggested GitHub Description

> HPC benchmarking and workload optimization toolkit for Slurm, Lustre, MPI profiling, IOR, and OSU Micro-Benchmarks. Includes scheduler efficiency analytics, bottleneck detection, and storage stripe tuning automation.

---

## Suggested Resume Bullet

**HPC Workload Optimization & Benchmarking:** Built a hands-on HPC benchmarking toolkit for Slurm, Lustre, MPI, IOR, and OSU Micro-Benchmarks; automated job efficiency analysis, scheduler bottleneck detection, Lustre stripe sweep testing, and I/O throughput reporting for scientific computing environments.

---

## License

MIT License. See [LICENSE](LICENSE).
