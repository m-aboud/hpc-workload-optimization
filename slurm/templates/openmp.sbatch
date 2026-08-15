#!/bin/bash
#SBATCH --job-name=openmp_demo
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=00:10:00
#SBATCH --output=openmp-%j.out
set -euo pipefail
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
gcc -O3 -fopenmp examples/src/openmp_pi.c -o /tmp/openmp_pi_${SLURM_JOB_ID}
srun /tmp/openmp_pi_${SLURM_JOB_ID}
