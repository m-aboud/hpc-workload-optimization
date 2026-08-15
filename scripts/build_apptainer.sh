#!/usr/bin/env bash
set -euo pipefail
IMAGE=${1:-hpc-research.sif}
command -v apptainer >/dev/null || { echo "apptainer not found" >&2; exit 1; }
apptainer build "$IMAGE" containers/Apptainer.def
echo "Built $IMAGE"
