#!/bin/bash
#SBATCH --job-name=fortran_omp
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=00:10:00
set -euo pipefail
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
gfortran -O3 -fopenmp examples/src/fortran_openmp.f90 -o /tmp/fortran_omp_${SLURM_JOB_ID}
srun /tmp/fortran_omp_${SLURM_JOB_ID}
