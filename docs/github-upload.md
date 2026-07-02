# GitHub Upload Guide

## 1. Create the repository

Create a new GitHub repository named:

```text
hpc-workload-optimization
```

Suggested description:

```text
HPC benchmarking and workload optimization toolkit for Slurm, Lustre, MPI profiling, IOR, and OSU Micro-Benchmarks.
```

Suggested topics:

```text
hpc slurm mpi lustre ior osu-micro-benchmarks benchmarking workload-optimization scientific-computing linux python bash
```

## 2. Upload from local machine

```bash
unzip hpc-workload-optimization-ready.zip
cd hpc-workload-optimization
git init
git add .
git commit -m "Initial release: HPC workload optimization toolkit"
git branch -M main
git remote add origin https://github.com/m-aboud/hpc-workload-optimization.git
git push -u origin main
```

## 3. Validate after upload

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
make test
make demo
```

## 4. Pin the repository

After pushing, pin it on the GitHub profile because this repo is strong for HPC, data center, infrastructure, and AI infrastructure roles.
