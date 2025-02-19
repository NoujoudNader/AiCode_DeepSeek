# Matrix Multiplication Implementations

Parallel matrix multiplication implementations in multiple programming languages.

## Fortran

### Compilation
```bash
gfortran -fopenmp -O3 -o matmul matmul.f90
```

### Execution
```bash
OMP_NUM_THREADS=<NUM_THREADS> ./matmul
```

---

## Julia

### Execution
```bash
JULIA_NUM_THREADS=<NUM_THREADS> julia matrix_mult.jl
```

---

## Python

### Execution
```bash
python matrix_mult.py
```

---

## C++

### Compilation
```bash
g++ -fopenmp -O3 -o matrix_mult matrix_mult.cpp
```

### Execution
```bash
./matrix_mult
```

---

## Configuration Notes
1. Replace `<NUM_THREADS>` with your core count (Fortran/Julia)

## Dependencies
- Fortran/C++: OpenMP runtime
- Julia: Multithreading support (1.6+)
- Python: NumPy (for typical matrix implementations)
