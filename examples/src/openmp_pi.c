#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    long n = argc > 1 ? atol(argv[1]) : 10000000L;
    double sum = 0.0;
    #pragma omp parallel for reduction(+:sum)
    for (long i = 0; i < n; ++i) {
        double x = (i + 0.5) / (double)n;
        sum += 4.0 / (1.0 + x * x);
    }
    printf("threads=%d pi=%.12f\n", omp_get_max_threads(), sum / n);
    return 0;
}
