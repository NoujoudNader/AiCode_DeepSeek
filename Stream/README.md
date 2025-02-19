# STREAM Triad Benchmark Implementation

This repository contains implementations of the STREAM triad benchmark (A[i] = B[i] + scalar*C[i]) in multiple programming languages. Below are the compilation and execution instructions for each version.

---

## C++ Implementation

### Compilation
```bash
# Compile with OpenMP and architecture-specific optimizations
g++ -O3 -march=native -fopenmp -std=c++17 stream_triad.cpp -o stream_triad
