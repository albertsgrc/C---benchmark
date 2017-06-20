#!/usr/bin/env node

function matrixMul(N) {
    var A = new Array(N), B = new Array(N), R = new Array(N);
    for (var i = 0; i < N; ++i) {
        A[i] = new Array(N); B[i] = new Array(N); R[i] = new Array(N);
    }

    for (var i = 0; i < N; ++i)
        for (var j = 0; j < N; ++j)
            for (var k = 0; k < N; ++k)
                R[i][j] = A[i][k]*B[k][j];
}

var N = parseInt(process.argv[2]);

matrixMul(N);
