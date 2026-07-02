# Benchmark Methodology

## Objective

Measure workload behavior across scheduler, compute, MPI communication, and parallel file-system layers.

## Benchmark phases

### Phase 1: Scheduler baseline

Collect 7-30 days of Slurm accounting data and classify jobs by:

- CPU efficiency
- Memory efficiency
- Walltime efficiency
- Queue wait time
- Failed or cancelled jobs
- Partition/QOS pressure

### Phase 2: Storage I/O benchmark

Run IOR across selected storage tiers and compare:

- Write throughput
- Read throughput
- Transfer size sensitivity
- Block size sensitivity
- POSIX vs MPI-IO behavior
- Lustre stripe count and stripe size impact

### Phase 3: MPI fabric benchmark

Use OSU Micro-Benchmarks to measure:

- Small-message latency
- Large-message bandwidth
- Variability between runs
- Node placement sensitivity

### Phase 4: Recommendation report

Create an operational report with:

- Top bottleneck categories
- Recommended scheduler policy changes
- Recommended user guidance
- Recommended storage defaults by workload pattern
- Follow-up tests

## Repeatability controls

- Run at least 3 repetitions for I/O tests.
- Keep test file paths unique per run.
- Avoid running during uncontrolled maintenance windows unless testing fault impact.
- Record module versions, MPI version, Slurm partition, node count, tasks per node, and storage path.

## Interpreting results

Do not rely on a single benchmark run. HPC performance can vary due to placement, network congestion, metadata load, OST imbalance, and other users' workloads.
