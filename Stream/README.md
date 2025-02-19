# STREAM Triad Benchmark Implementations

Parallel implementations of the STREAM triad operation (A[i] = B[i] + scalar*C[i]) in multiple programming languages.

## C++ Implementation

### Compilation
```bash
# Compile with OpenMP and architecture optimizations
g++ -O3 -march=native -fopenmp -std=c++17 stream_triad.cpp -o stream_triad
```

### Execution
```bash
# Set thread affinity (Linux)
export OMP_NUM_THREADS=$(nproc)
export OMP_PROC_BIND=close
export OMP_PLACES=cores

# Run benchmark
./stream_triad
```

### Expected Output
```bash
STREAM Triad Benchmark
Array size: 134217728 elements (1073.74 MB each)
Threads: 16
Time: 0.045723 seconds
Bandwidth: 84.3162 GB/s
First 3 elements: [7, 7, 7]
```

---

## Fortran Implementation

### Compilation
```bash
# Compile with OpenCoarrays (GCC)
caf -O3 -march=native -fopenmp -fcoarray=lib stream_triad.f90 -o stream_triad
```

### Execution
```bash
# Run with multiple processes
cafrun -n <NUM_PROCESSES> ./stream_triad
```

### Expected Output
```bash
STREAM Triad Benchmark Results:
 Number of images: 4
 Array size: 134217728 elements per array
 Total time:  0.047 seconds
 Bandwidth:  67.2 GB/s
 Sample values:     7.0    7.0    7.0
```

---

## Julia Implementation

### Execution
```bash
# Run with multiple threads
julia -t <NUM_THREADS> stream_triad.jl
```
### Expected Output
```bash
STREAM Triad Benchmark
Array size: 100000000 elements (762.94 MB each)
Threads: 4
Average time: 0.02345 s
Bandwidth: 98.76 GB/s
First element: 7.0
```
---

## Configuration Notes
1. Adjust array sizes (`N`) in source files according to available memory
2. Set `<NUM_PROCESSES>` (Fortran) and `<NUM_THREADS>` (Julia) to match your CPU cores
3. Compilation flags may vary by compiler/architecture
4. For NUMA systems, consider first-touch memory policy
5. Ensure required dependencies are installed:
   - OpenMP (C++/Fortran)
   - OpenCoarrays (Fortran)
   - Julia 1.6+ with multithreading support
