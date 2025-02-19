# STREAM Triad Benchmark Implementation

This repository contains implementations of the STREAM triad benchmark (A[i] = B[i] + scalar*C[i]) in multiple programming languages. Below are the compilation and execution instructions for each version.

---

## C++ Implementation

### Compilation
```bash
# Compile with OpenMP and architecture-specific optimizations
g++ -O3 -march=native -fopenmp -std=c++17 stream_triad.cpp -o stream_triad

### Execution
```bash
# Set thread affinity (Linux)
export OMP_NUM_THREADS=$(nproc)
export OMP_PROC_BIND=close
export OMP_PLACES=cores

# Run benchmark
./stream_triad

### Expected Output
STREAM Triad Benchmark
Array size: 134217728 elements (1073.74 MB each)
Threads: 16
Time: 0.045723 seconds
Bandwidth: 84.3162 GB/s
First 3 elements: [7, 7, 7]
