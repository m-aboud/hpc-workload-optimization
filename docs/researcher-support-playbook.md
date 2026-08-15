# Researcher / Faculty HPC Support Playbook

## 1. Start with the science objective
Capture the application, dataset size, expected result, deadline, prior baseline, scaling target, and whether the workload is CPU-, GPU-, memory-, I/O-, or communication-intensive.

## 2. Reproduce the failure or inefficiency
Collect job ID, Slurm reason/state, stdout/stderr, module/container environment, requested resources, actual usage, storage path, node list, MPI/compiler versions and relevant application settings.

## 3. Scheduler triage
Use `squeue`, `scontrol show job`, `sacct`, `sprio` and partition/QOS policy to distinguish policy wait from resource scarcity or dependency problems.

## 4. Right-size resources
Compare allocated vs consumed CPU, memory, GPU and walltime. Avoid automatically reducing requests where peak-memory or checkpoint phases justify headroom.

## 5. Programming-model review
- **OpenMP**: single-node shared-memory parallelism.
- **MPI**: distributed-memory scaling across processes/nodes.
- **Hybrid MPI+OpenMP**: fewer ranks with threaded intra-node work where appropriate.
- **OpenACC**: directive-based accelerator offload where supported.
- **Fortran**: common in scientific codes; focus on compiler/runtime/module compatibility and optimization flags.

## 6. Container / environment reproducibility
Use Apptainer when a reproducible user-space environment is needed without giving containerized jobs daemon-level privileges. Validate bind mounts, MPI ABI, GPU passthrough, filesystems and licensing.

## 7. Storage / I/O analysis
Measure rather than guess. Use IOR for controlled I/O tests, `lfs getstripe`/`setstripe` for Lustre, and vendor-native telemetry for Spectrum Scale/GPFS, Weka or VAST where available.

## 8. Fabric / scaling analysis
Use OSU microbenchmarks, MPI profiling, topology and placement data to identify latency, bandwidth, oversubscription or cross-fabric issues.

## 9. Close with an evidence-based recommendation
Document the baseline, change, observed result, limitations and rollback. The goal is reproducible improvement, not benchmark chasing.

## Research benefit
A consistent support method shortens time-to-result, reduces repeated failed jobs, improves knowledge transfer and helps researchers use shared infrastructure responsibly.
