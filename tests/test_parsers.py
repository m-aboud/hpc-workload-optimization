from hpcopt.ior_parser import parse_ior_text
from hpcopt.osu_parser import parse_osu_text


def test_parse_ior_text():
    text = """
api                : MPIIO
blockSize          = 4g
transferSize       = 16m
write       12450.23    11990.10    12180.55    188.10
read        14120.44    13780.12    13990.87    140.33
"""
    df = parse_ior_text(text)
    assert len(df) == 2
    assert df.loc[0, "operation"] == "write"
    assert df.loc[0, "mean_mib_s"] == 12180.55


def test_parse_osu_latency():
    text = """
# Size Latency
0 1.22
1024 5.10
"""
    df = parse_osu_text(text, kind="latency")
    assert len(df) == 2
    assert df.loc[1, "message_size_bytes"] == 1024
    assert df.loc[1, "latency_us"] == 5.10
