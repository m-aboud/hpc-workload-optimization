# HPC Workload Optimization & Research Computing Operations

Portfolio-grade HPC operations and performance toolkit demonstrating practical administration patterns for **Slurm**, **Lustre**, **MPI**, **Apptainer/Singularity**, **OpenMP**, **OpenACC**, **Fortran**, high-speed fabrics, Linux node hardening, and scientific workload support.

> **Scope:** lab/reference implementation. Cluster-specific commands, package names, partitions, QOS values, storage paths, kernel policy, and security baselines must be validated against the target HPC environment before production use.

## Why this project exists

HPC operations is not only about keeping nodes online. A strong research-computing platform helps researchers obtain results faster while protecting scarce CPU/GPU, memory, storage, and network capacity.

This repository demonstrates how an HPC administrator can turn scheduler, storage, fabric, container, and node telemetry into actions that improve:

- **Researcher productivity** — reusable Slurm templates, Apptainer workflows, and programming-model examples reduce setup friction.
- **Cluster utilization** — QOS/accounting analysis surfaces over-requested CPU, memory, and walltime that reduce schedulability.
- **Time-to-result** — IOR, OSU and MPI profiling help isolate storage or communication bottlenecks.
- **Reliability & security** — node hardening, kernel/package audit, configuration checks, and safe operating procedures reduce drift and maintenance risk.
- **CAPEX efficiency** — evidence-based right-sizing helps defer unnecessary compute/storage expansion and improves return on HPC investment.

## Capability map

| Area | Demonstrated evidence |
|---|---|
| Slurm scheduling | `sacct`, `squeue`, `sinfo`, QOS/partition review, accounting policy, walltime/backfill analysis, job-efficiency scoring |
| Scientific containers | Apptainer definition file, reproducible image build/run workflow, bind-mount guidance, Slurm container job template |
| Programming models | MPI, OpenMP, Fortran+OpenMP, OpenACC GPU example, CUDA-adjacent operational guidance |
| Parallel storage | Lustre stripe sweep, IOR matrix, GPFS/Spectrum Scale, Weka and VAST operational comparison guide |
| High-speed networking | OSU latency/bandwidth benchmark wrapper, MPI profiling, InfiniBand/RDMA/RoCE interpretation guidance |
| Linux node operations | Kernel/package patch audit, sysctl/SSH/security checks, drift-oriented reporting, maintenance checklist |
| Researcher support | Intake/runbook covering failed jobs, scaling, memory, I/O, environment modules, containers and code/runtime tuning |
| Automation | Bash + Python tools, reproducible configs, tests, CI lint/test workflow |

## Repository structure

```text
.
├── configs/                    # Cluster/QOS examples
├── containers/                 # Apptainer definition
├── docs/                       # Admin + researcher support playbooks
├── examples/
│   ├── src/                    # MPI/OpenMP/Fortran/OpenACC examples
│   └── sample-reports/         # Example outputs for portfolio browsing
├── scripts/                    # Slurm, storage, fabric, node and container automation
├── slurm/templates/            # sbatch templates
├── src/hpcopt/                 # Python scheduler efficiency CLI
└── tests/                      # Unit tests
```

## Quick start — laptop demo

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
make demo
```

Demo mode analyzes sanitized scheduler data without requiring Slurm or Lustre.

## Cluster workflows

### 1) Collect scheduler accounting and generate an efficiency report

```bash
bash scripts/collect_slurm_accounting.sh --days 14 --output reports/sacct_last14d.csv
hpcopt slurm-report --input reports/sacct_last14d.csv --output reports/slurm_efficiency_report.md
```

### 2) Review Slurm QOS / partition policy

```bash
bash scripts/audit_slurm_qos.sh --output reports/slurm_qos_audit.txt
```

The script inspects configured partitions/QOS associations and highlights admin review points such as default QOS, limits, preemption, fair-share/accounting visibility, and policy consistency.

### 3) Run a scientific workload in Apptainer

```bash
apptainer build hpc-research.sif containers/Apptainer.def
sbatch slurm/templates/apptainer_mpi.sbatch
```

### 4) Benchmark parallel storage

```bash
bash scripts/run_ior_sweep.sh --target /lustre/scratch/$USER/hpcopt --nodes 2 --ntasks-per-node 32
```

### 5) Benchmark MPI fabric

```bash
bash scripts/run_osu_latency_bw.sh --nodes 2 --output reports/osu_raw
```

### 6) Audit Linux compute-node hardening / patch state

```bash
sudo bash scripts/node_hardening_audit.sh --output reports/node_hardening.txt
```

This is **read-only**: it reports state and does not apply kernel, SSH, sysctl, firewall, or package changes.

## Researcher-facing support examples

See [`docs/researcher-support-playbook.md`](docs/researcher-support-playbook.md) for a structured workflow that starts from the research objective and works downward through scheduler, CPU/GPU, memory, MPI, storage, container, module and code-runtime dependencies.

Typical support questions this repository is designed to answer:

- Why is my job pending even though nodes look idle?
- Why did a job request 1 TB of RAM but use only 180 GB?
- Why does scaling flatten after 8 or 16 MPI ranks?
- Should this workload use MPI, OpenMP, hybrid MPI+OpenMP, OpenACC, or GPU-native execution?
- Is the slowdown compute-bound, memory-bound, I/O-bound, or fabric-bound?
- Should the workload run in Apptainer rather than a manually managed software environment?
- Which Lustre stripe setting fits the file size and access pattern?

## Safe-use principles

1. Run benchmarks only on approved partitions and agreed windows.
2. Do not run IOR against shared project storage without approval.
3. Use sanitized scheduler records for portfolio/public examples.
4. Treat QOS, security, kernel, firmware and filesystem changes as controlled production changes.
5. Never publish real usernames, account IDs, project names, cluster hostnames, or raw research data.

## Resume-ready project description

**HPC Workload Optimization & Research Computing Operations** — Built an HPC operations toolkit covering Slurm QOS/accounting and job-efficiency analysis, Lustre/IOR storage benchmarking, MPI/OSU fabric testing, Apptainer scientific containers, Linux node-hardening audits, and MPI/OpenMP/Fortran/OpenACC workload examples; translates technical findings into researcher productivity, cluster-utilization, reliability, and capacity-planning outcomes.

## License

MIT. See `LICENSE`.
