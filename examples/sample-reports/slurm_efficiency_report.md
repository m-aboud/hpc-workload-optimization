# Slurm Scheduler Efficiency Report

## Executive Summary

- Jobs analyzed: **6**
- Average CPU efficiency: **46.5%**
- Average memory efficiency: **35.1%**
- Average walltime efficiency: **22.3%**
- Average queue wait: **70.2 minutes**
- Jobs with findings: **5**

## Finding Distribution

| Finding                                                                                       |   Count |
|:----------------------------------------------------------------------------------------------|--------:|
| walltime_over_requested                                                                       |       2 |
| low_cpu_efficiency, walltime_over_requested                                                   |       1 |
| critical_low_cpu_efficiency, memory_over_requested, walltime_over_requested, long_queue_wait  |       1 |
| healthy_or_no_major_signal                                                                    |       1 |
| job_state_review, critical_low_cpu_efficiency, memory_over_requested, walltime_over_requested |       1 |

## Lowest CPU Efficiency Jobs

|   JobIDRaw | JobName           | Partition   | State     |   AllocCPUS |   CPUEfficiency | Finding                                                                                       |
|-----------:|:------------------|:------------|:----------|------------:|----------------:|:----------------------------------------------------------------------------------------------|
|      10006 | failed_mpi_run    | compute     | FAILED    |         256 |        0.015625 | job_state_review, critical_low_cpu_efficiency, memory_over_requested, walltime_over_requested |
|      10003 | python_preprocess | compute     | COMPLETED |          32 |        0.04     | critical_low_cpu_efficiency, memory_over_requested, walltime_over_requested, long_queue_wait  |
|      10001 | mpi_cfd_case      | compute     | COMPLETED |         512 |        0.420101 | low_cpu_efficiency, walltime_over_requested                                                   |
|      10004 | checkpoint_heavy  | compute     | COMPLETED |         128 |        0.675347 | healthy_or_no_major_signal                                                                    |
|      10005 | short_debug       | debug       | COMPLETED |           4 |        0.75     | walltime_over_requested                                                                       |
|      10002 | genomics_align    | compute     | COMPLETED |          64 |        0.889205 | walltime_over_requested                                                                       |

## Lowest Walltime Efficiency Jobs

|   JobIDRaw | JobName           | Partition   | State     |   ElapsedSeconds |   TimelimitSeconds |   WalltimeEfficiency | Finding                                                                                       |
|-----------:|:------------------|:------------|:----------|-----------------:|-------------------:|---------------------:|:----------------------------------------------------------------------------------------------|
|      10003 | python_preprocess | compute     | COMPLETED |             1500 |              43200 |            0.0347222 | critical_low_cpu_efficiency, memory_over_requested, walltime_over_requested, long_queue_wait  |
|      10006 | failed_mpi_run    | compute     | FAILED    |              300 |               7200 |            0.0416667 | job_state_review, critical_low_cpu_efficiency, memory_over_requested, walltime_over_requested |
|      10001 | mpi_cfd_case      | compute     | COMPLETED |             7200 |              86400 |            0.0833333 | low_cpu_efficiency, walltime_over_requested                                                   |
|      10005 | short_debug       | debug       | COMPLETED |              360 |               1800 |            0.2       | walltime_over_requested                                                                       |
|      10002 | genomics_align    | compute     | COMPLETED |             3300 |              14400 |            0.229167  | walltime_over_requested                                                                       |
|      10004 | checkpoint_heavy  | compute     | COMPLETED |            32400 |              43200 |            0.75      | healthy_or_no_major_signal                                                                    |

## Recommended Actions

1. Review jobs below 40% CPU efficiency and validate MPI/OpenMP layout.
2. Identify repeated memory over-requesting and publish workload-specific templates.
3. Encourage realistic walltime requests to improve backfill opportunities.
4. For long queue waits, compare partition pressure, QOS limits, and fairshare behavior.
5. Re-run this report weekly and trend improvements over time.
