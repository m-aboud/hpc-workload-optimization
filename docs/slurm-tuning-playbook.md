# Slurm Tuning Playbook

## Metrics to monitor

| Metric | Why it matters | Possible action |
|---|---|---|
| CPU efficiency | Indicates underutilized allocated cores | Tune `--ntasks`, `--cpus-per-task`, MPI/OpenMP layout |
| Memory efficiency | Indicates over-requested memory | Educate users, add memory request templates |
| Walltime efficiency | Impacts backfill and queue prediction | Recommend realistic `--time` values |
| Queue wait time | Reveals partition/QOS pressure | Review limits, fairshare, preemption, backfill |
| Job failure rate | Shows application or environment instability | Improve templates, modules, pre-flight checks |

## Example user guidance

### MPI workloads

```bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
srun --cpu-bind=cores ./my_mpi_app
```

### Hybrid MPI/OpenMP workloads

```bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=8
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun --cpu-bind=cores ./my_hybrid_app
```

## Operational recommendations

1. Publish standard job templates by workload type.
2. Review jobs with CPU efficiency below 40%.
3. Review jobs with memory efficiency below 25%.
4. Encourage shorter walltime requests for backfill-friendly workloads.
5. Use job arrays for many similar short jobs instead of thousands of individual submissions.
6. Track partition pressure weekly and tune QOS limits based on evidence.
