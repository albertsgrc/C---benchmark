#include <cstdlib>

int fib(int n) {
    if (n < 2) return n;
    else return fib(n - 2) + fib(n - 1);
}

int main(int argc, char* argv[]) {
    int N = atoi(argv[1]);
    fib(N);
}
