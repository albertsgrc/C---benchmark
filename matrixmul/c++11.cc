#include <cstdlib>

void matrix_mul(int N) {
    double **A = new double*[N], **B = new double*[N], **R = new double*[N];
    for (int i = 0; i < N; ++i) {
        A[i] = new double[N]; B[i] = new double[N]; R[i] = new double[N];
    }

    for (int i = 0; i < N; ++i)
        for (int j = 0; j < N; ++j)
            for (int k = 0; k < N; ++k)
                R[i][j] = A[i][k]*B[k][j];
}

int main(int argc, char* argv[]) {
    int N = atoi(argv[1]);

    matrix_mul(N);
}
