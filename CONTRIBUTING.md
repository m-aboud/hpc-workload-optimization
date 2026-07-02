# Contributing

Contributions should preserve the operational focus of this project: repeatable HPC benchmarking, safe cluster execution, clear reporting, and sanitized data.

## Development workflow

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
make test
make demo
```

## Data policy

Do not commit production cluster hostnames, usernames, account IDs, project IDs, raw accounting records, or benchmark results that reveal sensitive infrastructure capacity unless explicitly approved.
