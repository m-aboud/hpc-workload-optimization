#!/usr/bin/env bash
set -euo pipefail

TARGET=""
STRIPE_COUNTS="1 2 4 8 16"
STRIPE_SIZES="1m 4m 16m"
NODES=1
NTASKS_PER_NODE=16
OUTPUT="reports/ior_raw"

usage() {
  cat <<USAGE
Usage: $0 --target PATH [--stripe-counts "1 2 4 8"] [--stripe-sizes "1m 4m"] [--nodes N] [--ntasks-per-node N]

Applies Lustre stripe settings and runs IOR per layout.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --stripe-counts) STRIPE_COUNTS="$2"; shift 2 ;;
    --stripe-sizes) STRIPE_SIZES="$2"; shift 2 ;;
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

command -v lfs >/dev/null || { echo "lfs command not found; run on a Lustre client" >&2; exit 1; }
mkdir -p "$TARGET" "$OUTPUT"
TOTAL_TASKS=$((NODES * NTASKS_PER_NODE))

for count in $STRIPE_COUNTS; do
  for size in $STRIPE_SIZES; do
    testdir="$TARGET/stripe_c${count}_s${size}"
    rm -rf "$testdir"
    mkdir -p "$testdir"
    lfs setstripe --stripe-count="$count" --stripe-size="$size" "$testdir"
    lfs getstripe "$testdir" | tee "$OUTPUT/lustre_stripe_c${count}_s${size}.layout"

    label="ior_lustre_c${count}_s${size}_n${NODES}_ppn${NTASKS_PER_NODE}"
    srun --nodes="$NODES" --ntasks="$TOTAL_TASKS" \
      ior -a MPIIO -t 16m -b 4g -o "$testdir/${label}.dat" -C -e -k \
      | tee "$OUTPUT/${label}.out"
    rm -f "$testdir/${label}.dat"
  done
done
