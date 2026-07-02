import pandas as pd

from hpcopt.slurm_efficiency import normalize_sacct


def test_normalize_sacct_cpu_efficiency():
    df = pd.DataFrame(
        [
            {
                "JobIDRaw": "1",
                "JobName": "test",
                "Partition": "compute",
                "State": "COMPLETED",
                "ElapsedRaw": "100",
                "TimelimitRaw": "10",
                "AllocCPUS": "10",
                "ReqMem": "10G",
                "MaxRSS": "2G",
                "TotalCPU": "00:08:20",
            }
        ]
    )
    out = normalize_sacct(df)
    assert round(out.loc[0, "CPUEfficiency"], 2) == 0.50
    assert "low_cpu_efficiency" in out.loc[0, "Finding"]
