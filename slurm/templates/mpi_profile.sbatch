#!/bin/bash
#SBATCH --job-name=hpcopt_mpi_profile
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --time=01:00:00
#SBATCH --output=reports/hpcopt_mpi_profile_%j.out
#SBATCH --error=reports/hpcopt_mpi_profile_%j.err

set -euo pipefail

module purge
module load openmpi || true

APP=${APP:-"./my_mpi_application"}
bash scripts/profile_mpi_job.sh \
  --app "$APP" \
  --nodes "$SLURM_JOB_NUM_NODES" \
  --ntasks-per-node "${SLURM_NTASKS_PER_NODE:-32}" \
  --output reports/mpi_profile_${SLURM_JOB_ID}
