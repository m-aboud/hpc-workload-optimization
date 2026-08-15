# HPC Linux Node Hardening & Kernel Patching

HPC security must preserve both protection and performance/driver compatibility.

## Patch workflow
1. Validate kernel, NVIDIA driver, CUDA, OFED/rdma-core, MPI and filesystem client compatibility.
2. Drain nodes in Slurm and verify no active workloads.
3. Capture baseline health, firmware/driver versions and fabric/storage state.
4. Patch a canary node or small maintenance cohort first.
5. Reboot where required; verify node registration, filesystems, GPU, RDMA, Slurm and monitoring.
6. Run smoke benchmarks (MPI/OSU, storage, GPU diagnostics as applicable).
7. Return nodes to service and monitor error rate/performance.
8. Maintain rollback package/kernel and recovery runbook.

## Hardening areas
- SSH policy and privileged access
- Unneeded services and packages
- Kernel/sysctl security controls
- Time synchronization
- Audit/log forwarding
- Firewall/segmentation consistent with MPI/RDMA architecture
- Signed/controlled software and image sources

## Business benefit
Canary patching and compatibility validation reduce outage risk while maintaining security posture and research availability.
