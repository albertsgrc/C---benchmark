#!/usr/bin/env node

function collatz(n) {
    if (n%2 == 0) return n/2;
    return 3*n+1;
}

function sequence(n) {
    while (n != 1) {
        n = collatz(n);
    }
}

function sequences_collatz(n) {
    for (let i = 1; i <= n; ++i) {
        sequence(i);
    }
}

var N = parseInt(process.argv[2]);

sequences_collatz(N);
