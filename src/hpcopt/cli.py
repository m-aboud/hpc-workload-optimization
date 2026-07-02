from __future__ import annotations

import argparse

from rich.console import Console

from .ior_parser import parse_ior_path
from .osu_parser import parse_osu_path
from .report import write_bottleneck_report, write_slurm_report
from .slurm_efficiency import load_sacct_csv, normalize_sacct
from .utils import ensure_parent

console = Console()


def slurm_report(args: argparse.Namespace) -> None:
    df = normalize_sacct(load_sacct_csv(args.input))
    write_slurm_report(df, args.output)
    console.print(f"[green]Wrote Slurm report:[/green] {args.output}")


def parse_ior(args: argparse.Namespace) -> None:
    df = parse_ior_path(args.input)
    ensure_parent(args.output)
    df.to_csv(args.output, index=False)
    console.print(f"[green]Wrote IOR summary:[/green] {args.output}")


def parse_osu(args: argparse.Namespace) -> None:
    df = parse_osu_path(args.input, args.kind)
    ensure_parent(args.output)
    df.to_csv(args.output, index=False)
    console.print(f"[green]Wrote OSU summary:[/green] {args.output}")


def bottlenecks(args: argparse.Namespace) -> None:
    slurm_df = normalize_sacct(load_sacct_csv(args.sacct))
    ior_df = parse_ior_path(args.ior)
    write_bottleneck_report(slurm_df, ior_df, args.output)
    console.print(f"[green]Wrote bottleneck assessment:[/green] {args.output}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="hpcopt", description="HPC workload optimization toolkit")
    sub = parser.add_subparsers(required=True)

    p = sub.add_parser("slurm-report", help="Generate Slurm efficiency Markdown report")
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    p.set_defaults(func=slurm_report)

    p = sub.add_parser("parse-ior", help="Parse IOR output into CSV")
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    p.set_defaults(func=parse_ior)

    p = sub.add_parser("parse-osu", help="Parse OSU Micro-Benchmark output into CSV")
    p.add_argument("--input", required=True)
    p.add_argument("--kind", choices=["latency", "bandwidth"], required=True)
    p.add_argument("--output", required=True)
    p.set_defaults(func=parse_osu)

    p = sub.add_parser("bottlenecks", help="Generate combined bottleneck report")
    p.add_argument("--sacct", required=True)
    p.add_argument("--ior", required=True)
    p.add_argument("--output", required=True)
    p.set_defaults(func=bottlenecks)

    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
