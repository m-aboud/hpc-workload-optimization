#!/usr/bin/env bash
set -euo pipefail

TARGET=""
NODES=1
NTASKS_PER_NODE=16
OUTPUT="reports/ior_raw"
TRANSFER_SIZES="1m 4m 16m 64m"
BLOCK_SIZES="1g 4g"
API_MODES="POSIX MPIIO"

usage() {
  cat <<USAGE
Usage: $0 --target PATH [--nodes N] [--ntasks-per-node N] [--output DIR]

Runs an IOR benchmark sweep using srun. Requires IOR and Slurm on the cluster.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --nodes) NODES="$2"; shift 2 ;;
    --ntasks-per-node) NTASKS_PER_NODE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "--target is required" >&2
  usage
  exit 1
fi

mkdir -p "$TARGET" "$OUTPUT"
TOTAL_TASKS=$((NODES * NTASKS_PER_NODE))

for api in $API_MODES; do
  for transfer in $TRANSFER_SIZES; do
    for block in $BLOCK_SIZES; do
      label="ior_${api}_t${transfer}_b${block}_n${NODES}_ppn${NTASKS_PER_NODE}"
      outfile="$OUTPUT/${label}.out"
      echo "Running $label"
      srun --nodes="$NODES" --ntasks="$TOTAL_TASKS" \
        ior -a "$api" -t "$transfer" -b "$block" -o "$TARGET/${label}.dat" -C -e -k \
        | tee "$outfile"
      rm -f "$TARGET/${label}.dat"
    done
  done
done
