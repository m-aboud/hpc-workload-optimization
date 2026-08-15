#!/usr/bin/env bash
set -euo pipefail
OUTPUT="reports/node_hardening.txt"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) OUTPUT="$2"; shift 2;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
mkdir -p "$(dirname "$OUTPUT")"
{
  echo "HPC Compute Node Hardening / Patch Audit (read-only)"
  echo "Generated: $(date -Is)"
  echo
  echo "== OS / kernel =="
  uname -a
  cat /etc/os-release 2>/dev/null || true
  echo
  echo "== Reboot / patch indicators =="
  if command -v needs-restarting >/dev/null; then needs-restarting -r || true; fi
  if [[ -f /var/run/reboot-required ]]; then echo "reboot-required: YES"; else echo "reboot-required: not indicated"; fi
  if command -v dnf >/dev/null; then dnf -q check-update --security || true; fi
  if command -v apt-get >/dev/null; then apt list --upgradable 2>/dev/null | head -100 || true; fi
  echo
  echo "== SSH security posture =="
  sshd -T 2>/dev/null | grep -E 'permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries|allowtcpforwarding' || true
  echo
  echo "== Selected sysctl =="
  for k in kernel.kptr_restrict kernel.dmesg_restrict net.ipv4.conf.all.rp_filter net.ipv4.conf.default.rp_filter; do sysctl "$k" 2>/dev/null || true; done
  echo
  echo "== Firewall / time sync =="
  systemctl is-active firewalld 2>/dev/null || systemctl is-active ufw 2>/dev/null || true
  timedatectl show -p NTPSynchronized 2>/dev/null || true
  echo
  echo "== Admin review =="
  echo "- Compare kernel/firmware/driver stack against validated GPU/MPI support matrix before patching."
  echo "- Schedule kernel/driver updates through maintenance windows with drain, validation and rollback plans."
  echo "- Keep security baselines compatible with low-latency fabric, MPI and research software requirements."
} > "$OUTPUT"
echo "Wrote $OUTPUT"
