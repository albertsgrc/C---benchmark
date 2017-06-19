#!/usr/bin/env python3

import sys

def collatz(n):
    if (n%2 == 0): return n/2
    return 3*n+1

def sequence(n):
    while n != 1: n = collatz(n)

def sequences_collatz(n):
    for i in range(1, n+1): sequence(i)

N = int(sys.argv[1])

sequences_collatz(N)
