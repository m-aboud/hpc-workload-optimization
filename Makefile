.PHONY: demo test lint clean

demo:
	mkdir -p reports
	python -m hpcopt.cli slurm-report --input examples/sample_sacct.csv --output reports/slurm_efficiency_report.md
	cp reports/slurm_efficiency_report.md examples/sample-reports/slurm_efficiency_report.md
	@echo "Demo report: reports/slurm_efficiency_report.md"

test:
	pytest -q

lint:
	ruff check src tests
	bash -n scripts/*.sh slurm/templates/*.sbatch

clean:
	rm -rf reports/* .pytest_cache .ruff_cache src/*.egg-info src/hpc_workload_optimization.egg-info
	touch reports/.gitkeep
