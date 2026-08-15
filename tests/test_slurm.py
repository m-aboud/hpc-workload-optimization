from pathlib import Path
from hpcopt.slurm import Job, classify, load_jobs, render_report


def test_classify_flags_inefficiency():
    j = Job("1", "COMPLETED", 100, 100, 2000, 1000, 100, 1000)
    m = classify(j)
    assert "low_cpu_efficiency" in m["findings"]
    assert "memory_overrequest" in m["findings"]
    assert "walltime_padding" in m["findings"]


def test_load_and_render():
    p = Path(__file__).parents[1] / "examples" / "sample_sacct.csv"
    jobs = load_jobs(p)
    assert len(jobs) == 4
    text = render_report(jobs)
    assert "Slurm Efficiency Report" in text
    assert "memory_overrequest" in text
