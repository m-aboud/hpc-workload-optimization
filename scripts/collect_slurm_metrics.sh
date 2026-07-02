#!/usr/bin/env bash
set -euo pipefail

DAYS=14
OUTPUT="reports/sacct_last14d.csv"

usage() {
  cat <<USAGE
Usage: $0 [--days N] [--output PATH]

Collect Slurm accounting records using sacct.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) DAYS="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

mkdir -p "$(dirname "$OUTPUT")"
START_DATE=$(date -d "${DAYS} days ago" +%F 2>/dev/null || date -v-${DAYS}d +%F)

sacct \
  --starttime "$START_DATE" \
  --parsable2 \
  --allocations \
  --format JobIDRaw,JobName,User,Account,Partition,State,Submit,Start,End,ElapsedRaw,TimelimitRaw,AllocCPUS,ReqMem,MaxRSS,TotalCPU,NNodes,NTasks,ExitCode \
  > "$OUTPUT"

echo "Wrote Slurm accounting export to $OUTPUT"
