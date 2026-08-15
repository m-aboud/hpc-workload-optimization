#!/usr/bin/env bash
set -euo pipefail
DAYS=14
OUTPUT="reports/sacct.csv"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) DAYS="$2"; shift 2;;
    --output) OUTPUT="$2"; shift 2;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
command -v sacct >/dev/null || { echo "sacct not found" >&2; exit 1; }
mkdir -p "$(dirname "$OUTPUT")"
START=$(date -d "${DAYS} days ago" +%Y-%m-%d)
# Raw operational export. Site-specific normalization into the demo schema should be handled separately.
sacct -S "$START" -X -n -P \
  -o JobIDRaw,State,Partition,QOS,Account,User,AllocCPUS,ElapsedRaw,TotalCPU,ReqMem,MaxRSS,TimelimitRaw,Start,End \
  > "$OUTPUT"
echo "Wrote $OUTPUT"
