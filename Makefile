.PHONY: demo test lint clean

demo:
	mkdir -p reports
	hpcopt slurm-report --input examples/sample_sacct.csv --output reports/slurm_efficiency_report.md
	hpcopt parse-ior --input examples/sample_ior.txt --output reports/ior_summary.csv
	hpcopt parse-osu --input examples/sample_osu_latency.txt --kind latency --output reports/osu_latency.csv
	hpcopt parse-osu --input examples/sample_osu_bw.txt --kind bandwidth --output reports/osu_bandwidth.csv
	hpcopt bottlenecks --sacct examples/sample_sacct.csv --ior examples/sample_ior.txt --output reports/bottleneck_assessment.md

test:
	pytest -q

lint:
	ruff check src tests

clean:
	rm -rf reports/*.csv reports/*.md reports/ior_raw reports/osu_raw .pytest_cache .ruff_cache
