#!/usr/bin/env python3

import sys, numpy

def matrixMul(N):
    A = numpy.zeros((N, N))
    B = numpy.zeros((N, N))
    R = numpy.zeros((N, N))

    for i in range(0, N):
        for j in range(0, N):
            for k in range(0, N):
                R[i][j] = A[i][k]*B[k][j]

N = int(sys.argv[1])
matrixMul(N)
