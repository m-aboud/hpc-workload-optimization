# HPC Programming Models — Administrator's Operational View

Administrators do not need to own research code to support it effectively; they do need to understand how the programming model maps to resources and runtime dependencies.

| Model | Typical resource pattern | Admin focus |
|---|---|---|
| MPI | multi-process / multi-node | rank placement, MPI ABI, fabric, latency/bandwidth |
| OpenMP | shared-memory threads | `--cpus-per-task`, affinity, NUMA, thread count |
| MPI + OpenMP | distributed + threaded | ranks-per-node vs threads, binding, memory locality |
| Fortran | scientific compiled workloads | compiler/modules, math libs, ABI, optimization flags |
| OpenACC | directive-based GPU offload | compiler, GPU partition, driver/runtime compatibility |
| CUDA | native NVIDIA GPU | driver/CUDA compatibility, GPU topology, memory, telemetry |

## Research benefit
Correct mapping between code parallelism and Slurm resource requests prevents idle CPUs, memory pressure, oversubscription and misleading scaling results.
