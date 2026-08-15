# Slurm Efficiency Report

| Job | State | CPU eff. | Memory eff. | Walltime eff. | Findings |
|---|---:|---:|---:|---:|---|
| 1001 | COMPLETED | 95.5% | 68.7% | 50.0% | none |
| 1002 | COMPLETED | 42.0% | 17.2% | 6.2% | low_cpu_efficiency, memory_overrequest, walltime_padding |
| 1003 | COMPLETED | 93.8% | 76.3% | 6.2% | walltime_padding |
| 1004 | FAILED | 20.8% | 22.9% | 8.3% | low_cpu_efficiency, memory_overrequest, walltime_padding |

## Operational interpretation

- **low_cpu_efficiency**: 2 job(s)
- **memory_overrequest**: 2 job(s)
- **walltime_padding**: 3 job(s)

Use these findings to start a researcher conversation before changing limits or QOS policy. Scheduler efficiency should be interpreted with workload science, scaling behavior and turnaround objectives in mind.
