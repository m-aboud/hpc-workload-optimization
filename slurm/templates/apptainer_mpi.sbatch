#!/bin/bash
#SBATCH --job-name=apptainer_mpi
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --time=00:15:00
set -euo pipefail
IMAGE=${IMAGE:-hpc-research.sif}
# Site MPI integration varies. Validate host/container MPI ABI compatibility before production use.
srun apptainer exec --bind "$PWD:$PWD" "$IMAGE" bash -lc \
  'cd "$PWD" && mpicc -O2 examples/src/mpi_hello.c -o /tmp/mpi_hello && /tmp/mpi_hello'
