import numpy as np
import numba as nb
import time
import os
from concurrent.futures import ThreadPoolExecutor

# Set environment variables for thread control
os.environ['OMP_NUM_THREADS'] = '4'
os.environ['MKL_NUM_THREADS'] = '1'

@nb.njit(nogil=True, parallel=True, fastmath=True)
def dgemm_parallel(A, B, C, alpha=1.0, beta=0.0, block_size=64):
    n = A.shape[0]
    Bt = np.empty_like(B)
    
    # Transpose B for better cache utilization
    for i in nb.prange(n):
        for j in range(n):
            Bt[j, i] = B[i, j]
    
    # Blocked matrix multiplication with parallelization
    for ii in nb.prange(0, n, block_size):
        for jj in range(0, n, block_size):
            for kk in range(0, n, block_size):
                i_end = min(ii + block_size, n)
                j_end = min(jj + block_size, n)
                k_end = min(kk + block_size, n)
                
                for i in range(ii, i_end):
                    for j in range(jj, j_end):
                        tmp = 0.0
                        for k in range(kk, k_end):
                            tmp += A[i, k] * Bt[j, k]
                        C[i, j] = alpha * tmp + beta * C[i, j]

@nb.njit(nogil=True, parallel=True)
def dgemm_naive(A, B, C, alpha=1.0, beta=0.0):
    n = A.shape[0]
    for i in nb.prange(n):
        for j in range(n):
            tmp = 0.0
            for k in range(n):
                tmp += A[i, k] * B[k, j]
            C[i, j] = alpha * tmp + beta * C[i, j]

def validate(ref, test, tol=1e-6):
    return np.allclose(ref, test, atol=tol)

def benchmark(matrix_sizes=[512, 1024, 2048], block_sizes=[32, 64, 128]):
    results = []
    
    for size in matrix_sizes:
        A = np.random.rand(size, size)
        B = np.random.rand(size, size)
        C_numpy = np.zeros((size, size))
        C_parallel = np.zeros((size, size))
        C_naive = np.zeros((size, size))
        
        # Numpy reference implementation
        start = time.perf_counter()
        ref = A @ B
        numpy_time = time.perf_counter() - start
        numpy_gflops = (2 * size**3) / numpy_time / 1e9
        
        # Warm-up Numba JIT
        dgemm_parallel(A, B, C_parallel)
        dgemm_naive(A, B, C_naive)
        
        # Benchmark parallel implementation with different block sizes
        for bs in block_sizes:
            C_parallel.fill(0.0)
            start = time.perf_counter()
            dgemm_parallel(A, B, C_parallel, bs)
            parallel_time = time.perf_counter() - start
            parallel_gflops = (2 * size**3) / parallel_time / 1e9
            valid = validate(ref, C_parallel)
            
            results.append((
                size, bs, 'Parallel',
                parallel_time, parallel_gflops, valid
            ))
        
        # Benchmark naive implementation
        C_naive.fill(0.0)
        start = time.perf_counter()
        dgemm_naive(A, B, C_naive)
        naive_time = time.perf_counter() - start
        naive_gflops = (2 * size**3) / naive_time / 1e9
        valid = validate(ref, C_naive)
        
        results.append((
            size, 'N/A', 'Naive',
            naive_time, naive_gflops, valid
        ))
        
        # Numpy results
        results.append((
            size, 'N/A', 'NumPy',
            numpy_time, numpy_gflops, True
        ))
    
    # Print results
    print(f"{'Size':<8} {'Block':<6} {'Method':<8} {'Time (s)':<10} {'GFLOPS':<10} {'Valid'}")
    print("="*60)
    for res in results:
        print(f"{res[0]:<8} {str(res[1]):<6} {res[2]:<8} {res[3]:<10.4f} {res[4]:<10.2f} {res[5]}")

if __name__ == "__main__":
    # Benchmark different configurations
    benchmark(
        matrix_sizes=[512, 1024, 2048],
        block_sizes=[32, 64, 128]
    )
