#include <stdio.h>
#define N 1000000
int main(void) {
    static float a[N], b[N], c[N];
    for (int i=0; i<N; ++i) { a[i]=(float)i; b[i]=2.0f; }
    #pragma acc parallel loop copyin(a[0:N], b[0:N]) copyout(c[0:N])
    for (int i=0; i<N; ++i) c[i] = a[i] + b[i];
    printf("c[999999]=%.1f\n", c[N-1]);
    return 0;
}
