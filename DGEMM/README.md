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

---

## Julia Implementation

### Execution
```bash
JULIA_NUM_THREADS=<NUM_THREADS> julia dgemm_benchmark.jl
```

---

## Python Implementation

### Execution
```bash
python dgemm_benchmark.py
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
