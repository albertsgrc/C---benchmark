#!/usr/bin/env python3

import sys

def isPrime(n):
    if n < 2: return False;
    if n == 2: return True;
    if n%2 == 0: return False;

    i = 3
    while (i*i) <= n:
        if n%i == 0: return False
        i +=2

    return True



N = int(sys.argv[1])

for i in range(1, N*100000 + 1): isPrime(i)
