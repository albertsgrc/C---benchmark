#include <cstdlib>

int isPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n%2 == 0) return false;

    for(int i = 3; (i*i) <= n; i += 2) {
        if (n%i == 0) return false;
    }

    return true;
}

int main(int argc, char* argv[]) {
    int N = atoi(argv[1]);

    for (int i = 1; i <= N*100000; ++i) {
        isPrime(i);
    }
}
