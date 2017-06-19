#!/usr/bin/env python3

import sys

def fib(n):
    if n < 2: return n
    else: return fib(n - 2) + fib(n - 1)

N = int(sys.argv[1])

fib(N)
