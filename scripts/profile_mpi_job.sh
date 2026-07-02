#!/usr/bin/env bash
set -euo pipefail

APP=""
NODES=1
NTASKS_PER_NODE=16
OUTPUT="reports/mpi_profile"

usage() {
  cat <<USAGE
Usage: $0 --app './my_mpi_app args' [--nodes N] [--ntasks-per-node N] [--output DIR]

Runs an MPI application with basic timing and optional mpiP/perf hints.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app) APP="$2"; shift 2 ;;
    --nodes) NODES="$2"; shift 2 ;;
    --ntasks-per-node) NTASKS_PER_NODE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$APP" ]]; then
  echo "--app is required" >&2
  usage
  exit 1
fi

mkdir -p "$OUTPUT"
TOTAL_TASKS=$((NODES * NTASKS_PER_NODE))

echo "Profiling command: $APP" | tee "$OUTPUT/run_metadata.txt"
echo "Nodes=$NODES Tasks=$TOTAL_TASKS TasksPerNode=$NTASKS_PER_NODE" | tee -a "$OUTPUT/run_metadata.txt"

/usr/bin/time -v srun --nodes="$NODES" --ntasks="$TOTAL_TASKS" --ntasks-per-node="$NTASKS_PER_NODE" bash -lc "$APP" \
  > "$OUTPUT/stdout.log" 2> "$OUTPUT/stderr_and_time.log"

echo "Profile complete. Review $OUTPUT/stderr_and_time.log and application-native timers."
echo "For deeper MPI attribution, relink with mpiP or run with your site's profiler module."
