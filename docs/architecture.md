# Architecture

This project separates HPC workload optimization into four evidence streams:

1. **Scheduler evidence** from Slurm accounting commands such as `sacct`.
2. **Storage evidence** from IOR and Lustre `lfs` stripe layout commands.
3. **MPI evidence** from OSU Micro-Benchmarks and optional MPI profilers.
4. **Decision evidence** from rule-based bottleneck detection.

## Data flow

```text
sacct CSV ---------> slurm_efficiency.py -----+
IOR output --------> ior_parser.py -----------+--> report.py --> Markdown/CSV reports
OSU output --------> osu_parser.py -----------+
manual thresholds -> bottleneck_rules.py -----+
```

## Intended audience

- HPC system engineers
- Research computing support teams
- Data center/HPC operations teams
- Scientific application support engineers
- Infrastructure architects evaluating cluster utilization

## Design principles

- **Evidence first:** every recommendation should be backed by a metric.
- **Cluster safe:** benchmark scripts isolate outputs and use explicit job names.
- **Portable:** sample mode runs without a real cluster.
- **Sanitized:** no real user, account, or cluster metadata is required.
