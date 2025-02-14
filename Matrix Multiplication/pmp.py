import numpy as np
import multiprocessing as mp
from time import time

def parallel_matrix_mult(A, B, num_workers=None):
    """
    Parallel matrix multiplication using multiprocessing
    A: numpy array of shape (m, n)
    B: numpy array of shape (n, p)
    Returns: numpy array of shape (m, p)
    """
    m, n = A.shape
    n, p = B.shape
    result = np.zeros((m, p))
    
    # Create pool of workers
    with mp.Pool(processes=num_workers) as pool:
        # Calculate chunk size
        chunk_size = m // (num_workers or mp.cpu_count()) or 1
        
        # Create tasks
        tasks = [(A[i:i+chunk_size], B) for i in range(0, m, chunk_size)]
        
        # Process tasks in parallel
        results = pool.starmap(np.dot, tasks)
        
        # Combine results
        result = np.vstack(results)
    
    return result

def validate(C1, C2, atol=1e-6):
    """Validate two matrices using numpy's allclose"""
    return np.allclose(C1, C2, atol=atol)

if __name__ == "__main__":
    # Matrix dimensions
    m, n, p = 512, 512, 512
    
    # Generate random matrices
    A = np.random.randn(m, n)
    B = np.random.randn(n, p)
    
    # Parallel multiplication
    start = time()
    C_parallel = parallel_matrix_mult(A, B, num_workers=mp.cpu_count())
    parallel_time = time() - start
    print(f"Parallel time: {parallel_time:.4f}s")
    
    # NumPy reference implementation
    start = time()
    C_numpy = np.dot(A, B)
    numpy_time = time() - start
    print(f"NumPy time: {numpy_time:.4f}s")
    
    # Validation
    if validate(C_parallel, C_numpy):
        print("Validation PASSED")
    else:
        print("Validation FAILED")
    
    print(f"Parallel/NumPy speed ratio: {parallel_time/numpy_time:.2f}x")
