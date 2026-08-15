# Slurm QOS, Accounting & Backfill Review

## Administrator objectives
A QOS policy should balance research turnaround, fairness, throughput, resource protection and operational simplicity.

## Review sequence
1. Inspect `scontrol show config` for scheduler, priority, preemption and accounting plugins.
2. Review partitions with `sinfo` and `scontrol show partition`.
3. Review QOS limits using `sacctmgr show qos`.
4. Review account/user associations and default QOS values.
5. Sample `sacct` history and calculate CPU, memory and walltime efficiency.
6. Look for walltime inflation that reduces backfill opportunities.
7. Discuss repeated inefficiency with researchers before enforcing policy changes.
8. Apply QOS changes through controlled change, validation and communication.

## Business / research benefit
- Better backfill and packing increases effective cluster capacity.
- Appropriate limits reduce queue monopolization and improve fairness.
- Accounting provides evidence for capacity planning and allocation decisions.
- Researcher coaching can improve efficiency without blunt administrative restrictions.
