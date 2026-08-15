#!/usr/bin/env bash
set -euo pipefail
OUTPUT="reports/slurm_qos_audit.txt"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) OUTPUT="$2"; shift 2;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
for c in scontrol sacctmgr sinfo; do command -v "$c" >/dev/null || { echo "$c not found" >&2; exit 1; }; done
mkdir -p "$(dirname "$OUTPUT")"
{
  echo "Slurm QOS / Accounting Audit"
  echo "Generated: $(date -Is)"
  echo
  echo "== Cluster / partitions =="
  scontrol show config | grep -E 'ClusterName|SchedulerType|PriorityType|PreemptType|AccountingStorageType' || true
  sinfo -o '%P|%a|%l|%D|%t|%G'
  echo
  echo "== QOS =="
  sacctmgr -n -P show qos format=Name,Priority,MaxWall,MaxJobsPU,MaxSubmitPU,GrpTRES,MaxTRESPU,Preempt,Flags
  echo
  echo "== Associations =="
  sacctmgr -n -P show assoc format=Cluster,Account,User,Partition,QOS,DefaultQOS,Fairshare
  echo
  echo "== Admin review points =="
  echo "- Validate default QOS and account/partition associations."
  echo "- Review MaxWall / MaxJobs / TRES limits against workload classes."
  echo "- Check whether walltime padding is reducing backfill opportunities."
  echo "- Confirm preemption and priority/fair-share policy is documented."
  echo "- Review stale accounts/users and exceptions as controlled changes."
} > "$OUTPUT"
echo "Wrote $OUTPUT"
