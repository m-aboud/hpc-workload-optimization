# Result Interpretation Guide

## Scheduler findings

### Low CPU efficiency

Likely causes:

- Too many MPI ranks requested
- Incorrect OpenMP thread count
- Load imbalance
- Serial bottleneck inside a parallel job
- I/O wait dominating runtime

Actions:

- Compare `TotalCPU` against allocated cores × elapsed time.
- Review rank/thread placement.
- Profile the application with `mpiP`, `perf`, or application-native timers.

### Low memory efficiency

Likely causes:

- Users requesting large memory as a safety margin
- Templates copied across unrelated workloads
- Partition rules encouraging over-requesting

Actions:

- Recommend measured memory-based requests.
- Create workload-specific examples.
- Consider partition-level education or policy changes.

## IOR findings

### Throughput improves with stripe count

This usually indicates that the workload benefits from spreading large sequential I/O across multiple OSTs.

### Throughput plateaus or drops

This can happen when client/network bandwidth, MPI layout, or OST contention becomes the bottleneck.

## MPI findings

### High small-message latency

Possible causes:

- Cross-rack placement
- Fabric congestion
- CPU frequency/power-management behavior
- MPI runtime configuration

### Low large-message bandwidth

Possible causes:

- NIC binding issue
- Suboptimal MPI transport
- Shared node contention
- Fabric oversubscription
