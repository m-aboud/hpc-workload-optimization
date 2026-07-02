#!/bin/bash
#SBATCH --job-name=hpcopt_ior
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --time=00:30:00
#SBATCH --output=reports/hpcopt_ior_%j.out
#SBATCH --error=reports/hpcopt_ior_%j.err

set -euo pipefail

module purge
module load openmpi ior || true

TARGET=${TARGET:-/lustre/scratch/$USER/hpcopt-ior}
mkdir -p "$TARGET" reports

bash scripts/run_ior_sweep.sh \
  --target "$TARGET" \
  --nodes "$SLURM_JOB_NUM_NODES" \
  --ntasks-per-node "${SLURM_NTASKS_PER_NODE:-32}" \
  --output reports/ior_raw
