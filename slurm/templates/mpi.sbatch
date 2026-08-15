#!/bin/bash
#SBATCH --job-name=mpi_demo
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --time=00:10:00
set -euo pipefail
mpicc -O2 examples/src/mpi_hello.c -o /tmp/mpi_hello_${SLURM_JOB_ID}
srun /tmp/mpi_hello_${SLURM_JOB_ID}
