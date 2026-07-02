#!/bin/bash
#SBATCH --job-name=hpcopt_osu
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:15:00
#SBATCH --output=reports/hpcopt_osu_%j.out
#SBATCH --error=reports/hpcopt_osu_%j.err

set -euo pipefail

module purge
module load openmpi osu-micro-benchmarks || true

mkdir -p reports/osu_raw
bash scripts/run_osu_latency_bw.sh --nodes 2 --ntasks-per-node 1 --output reports/osu_raw
