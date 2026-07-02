# Lustre Stripe Optimization

## Concepts

- **Stripe count:** number of OSTs used for a file.
- **Stripe size:** amount of contiguous data written to one OST before moving to the next stripe.
- **Wide striping:** can improve large sequential I/O, but can increase overhead for small files.

## Practical rules of thumb

| Workload pattern | Suggested starting point |
|---|---|
| Many small files | Default or low stripe count |
| Large sequential checkpoint files | Stripe count 4-16, stripe size 1-16 MiB |
| Shared read-heavy datasets | Test multiple layouts and use the best observed read throughput |
| Metadata-heavy workloads | Avoid unnecessary wide striping |

## Example commands

```bash
mkdir -p /lustre/scratch/$USER/checkpoints
lfs setstripe --stripe-count=8 --stripe-size=4m /lustre/scratch/$USER/checkpoints
lfs getstripe /lustre/scratch/$USER/checkpoints
```

## Validation process

1. Create a clean test directory.
2. Apply a stripe layout.
3. Run IOR with a controlled node/task count.
4. Capture read/write throughput.
5. Repeat for each stripe layout.
6. Select defaults by workload type, not globally.
