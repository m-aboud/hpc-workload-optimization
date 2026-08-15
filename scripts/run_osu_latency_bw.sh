#!/usr/bin/env bash
set -euo pipefail
NODES=2; OUTPUT="reports/osu_raw"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --nodes) NODES="$2"; shift 2;;
    --output) OUTPUT="$2"; shift 2;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
mkdir -p "$OUTPUT"
LAT=${OSU_LATENCY_BIN:-osu_latency}
BW=${OSU_BW_BIN:-osu_bw}
command -v srun >/dev/null || { echo "srun not found" >&2; exit 1; }
command -v "$LAT" >/dev/null || { echo "$LAT not found" >&2; exit 1; }
command -v "$BW" >/dev/null || { echo "$BW not found" >&2; exit 1; }
srun -N "$NODES" -n 2 "$LAT" | tee "$OUTPUT/osu_latency.out"
srun -N "$NODES" -n 2 "$BW" | tee "$OUTPUT/osu_bw.out"
