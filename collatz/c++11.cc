#include <cstdlib>

int collatz(int n) {
    if (n%2 == 0) return n/2;
    return 3*n+1;
}

void sequence(int n) {
    while (n != 1) {
        n = collatz(n);
    }
}

void sequences_collatz(int n) {
    for (int i = 1; i <= n; ++i) {
        sequence(i);
    }
}

int main(int argc, char* argv[]) {
    int N = atoi(argv[1]);
    sequences_collatz(N);
}
