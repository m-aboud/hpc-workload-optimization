# HPC Bottleneck Assessment

## Prioritized Signals

| Signal                       | Evidence                                                    | Recommended action                                                                              |
|:-----------------------------|:------------------------------------------------------------|:------------------------------------------------------------------------------------------------|
| Compute underutilization     | 2 jobs have CPU efficiency below 40%.                       | Profile rank/thread placement, application imbalance, and I/O wait.                             |
| Memory over-requesting       | 2 jobs used less than 25% of requested memory.              | Tune memory requests and publish templates.                                                     |
| Walltime padding             | 5 jobs used less than 35% of requested walltime.            | Encourage realistic walltime to improve backfill.                                               |
| Best observed I/O write path | sample_ior.txt reached 12180.5 MiB/s mean write throughput. | Use as a candidate layout for similar large-file workloads, then validate with application I/O. |

## Next Review Questions

- Are low-efficiency jobs concentrated by user, application, partition, or module version?
- Do I/O results change during peak hours versus quiet windows?
- Are MPI latency spikes correlated with node placement?
- Can templates reduce repeated over-allocation patterns?
