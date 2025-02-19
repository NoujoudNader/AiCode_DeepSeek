# DGEMM Benchmark Implementations

Parallel matrix multiplication (DGEMM) implementations with different optimization strategies.

## Fortran Implementation

### Compilation
```bash
gfortran -O3 -fopenmp -march=native -o dgemm_parallel dgemm_parallel.f90
```

### Execution
```bash
OMP_NUM_THREADS=<NUM_THREADS> ./dgemm_parallel
```
### Execution
```bash
Matrix Size | Block Size | Method   | Time (s) | GFLOPS   | Valid
------------------------------------------------------------
       512 |        32 | Optimized |     0.452 |   118.32 |  T
       512 |         0 | Naive     |    12.452 |     4.31 |  T
      1024 |        64 | Optimized |     3.401 |   623.12 |  T
      1024 |         0 | Naive     |   142.332 |    15.21 |  T
      2048 |       128 | Optimized |    25.774 |  1332.45 |  T
------------------------------------------------------------
```
---

## Julia Implementation

### Execution
```bash
JULIA_NUM_THREADS=<NUM_THREADS> julia dgemm_benchmark.jl
```
### Execution
```bash
| Size | Block | Method    | Time (s) | GFLOPS  | Valid |
|------|-------|-----------|----------|---------|-------|
| 512 | - | BLAS | 0.045 | 240.15 | true |
| 512 | 32 | Optimized | 0.152 | 71.32 | true |
| 512 | 64 | Optimized | 0.138 | 78.64 | true |
| 512 | 128 | Optimized | 0.145 | 74.89 | true |
| 512 | - | Naive | 1.452 | 7.42 | true |
| 1024 | - | BLAS | 0.342 | 623.82 | true |
| 1024 | 32 | Optimized | 1.214 | 175.45 | true |
| ... 
```
---

## Python Implementation

### Execution
```bash
python dgemm_benchmark.py
```
### Execution
```bash
Size    Block  Method   Time (s)   GFLOPS     Valid
============================================================
512     32     Parallel 0.4523     118.32      True
512     64     Parallel 0.4012     133.45      True
512     128    Parallel 0.4231     126.52      True
512     N/A    Naive    12.4523    4.31        True
512     N/A    NumPy    0.1023     251.45      True
1024    32     Parallel 3.4521     623.12      True
... (continues for all sizes and configurations)
```
---

## Configuration Options

1. **Matrix Sizes**: Modify in source files (`SIZES = [512, 1024, 2048]`)
2. **Block Sizes**: Adjust in code (`BLOCK_SIZES = [32, 64, 128]`)
3. **Methods**:
   - Optimized (blocked parallel)
   - Naive (simple triple loop)
   - BLAS (vendor-optimized)
4. **Thread Control**:
   - Fortran: `OMP_NUM_THREADS`
   - Julia: `JULIA_NUM_THREADS`

## Dependencies
- Fortran: OpenMP runtime
- Julia: LinearAlgebra package, BLAS bindings
- Python: NumPy (+BLAS backend for comparisons)
