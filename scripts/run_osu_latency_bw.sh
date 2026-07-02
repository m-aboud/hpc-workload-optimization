#!/usr/bin/env bash
set -euo pipefail

NODES=2
NTASKS_PER_NODE=1
OUTPUT="reports/osu_raw"
OSU_BIN_DIR="${OSU_BIN_DIR:-}"

usage() {
  cat <<USAGE
Usage: $0 [--nodes 2] [--ntasks-per-node 1] [--output DIR]

Runs OSU latency and bandwidth tests. Set OSU_BIN_DIR if binaries are not in PATH.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --nodes) NODES="$2"; shift 2 ;;
    --ntasks-per-node) NTASKS_PER_NODE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

mkdir -p "$OUTPUT"
LAT_BIN="${OSU_BIN_DIR:+$OSU_BIN_DIR/}osu_latency"
BW_BIN="${OSU_BIN_DIR:+$OSU_BIN_DIR/}osu_bw"

srun --nodes="$NODES" --ntasks=2 --ntasks-per-node="$NTASKS_PER_NODE" "$LAT_BIN" | tee "$OUTPUT/osu_latency.out"
srun --nodes="$NODES" --ntasks=2 --ntasks-per-node="$NTASKS_PER_NODE" "$BW_BIN" | tee "$OUTPUT/osu_bw.out"
