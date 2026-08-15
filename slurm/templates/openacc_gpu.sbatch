#!/bin/bash
#SBATCH --job-name=openacc_demo
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gpus=1
#SBATCH --time=00:10:00
set -euo pipefail
# Requires an OpenACC-capable compiler such as NVIDIA HPC SDK nvc.
command -v nvc >/dev/null || { echo "nvc compiler not available"; exit 1; }
nvc -O3 -acc examples/src/openacc_vector.c -o /tmp/openacc_${SLURM_JOB_ID}
srun /tmp/openacc_${SLURM_JOB_ID}
