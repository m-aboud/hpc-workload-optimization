#!/usr/bin/env bash
set -euo pipefail
TARGET=""; NODES=2; TPN=32; OUTPUT="reports/ior_raw"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2;;
    --nodes) NODES="$2"; shift 2;;
    --ntasks-per-node) TPN="$2"; shift 2;;
    --output) OUTPUT="$2"; shift 2;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
[[ -n "$TARGET" ]] || { echo "--target required" >&2; exit 2; }
command -v ior >/dev/null || { echo "ior not found" >&2; exit 1; }
command -v srun >/dev/null || { echo "srun not found" >&2; exit 1; }
mkdir -p "$TARGET" "$OUTPUT"
for BS in 1m 4m 16m; do
  for TS in 1m 4m; do
    OUT="$OUTPUT/ior_bs-${BS}_ts-${TS}.txt"
    srun -N "$NODES" --ntasks-per-node "$TPN" ior -a MPIIO -w -r -b "$BS" -t "$TS" -F -o "$TARGET/testfile" | tee "$OUT"
  done
done
