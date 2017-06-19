#!/usr/bin/env node

function fib(n) {
    if (n < 2) return n;
    else return fib(n - 2) + fib(n - 1);
}

var N = parseInt(process.argv[2]);

fib(N);
