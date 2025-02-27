import multiprocessing as mp
import numpy as np
import time

def triad_worker(args):
    start, end, scalar, A_shm, B_shm, C_shm = args
    # Attach shared memory blocks to numpy arrays
    A = np.frombuffer(A_shm, dtype=np.float64)
    B = np.frombuffer(B_shm, dtype=np.float64)
    C = np.frombuffer(C_shm, dtype=np.float64)
    # Perform the triad operation on the assigned chunk
    A[start:end] = B[start:end] + scalar * C[start:end]

def main():
    # Configuration
    N = 10**8  # Adjust based on available memory
    scalar = 3.0
    num_processes = mp.cpu_count()
    
    # Create shared memory arrays
    A_shm = mp.Array('d', N, lock=False)
    B_shm = mp.Array('d', N, lock=False)
    C_shm = mp.Array('d', N, lock=False)
    
    # Initialize B and C using numpy for faster operations
    with mp.Pool(1) as pool:  # Use a single process for initialization
        B_np = np.frombuffer(B_shm, dtype=np.float64)
        C_np = np.frombuffer(C_shm, dtype=np.float64)
        B_np[:] = 1.0  # Initialize B with 1.0
        C_np[:] = 2.0  # Initialize C with 2.0
    
    # Prepare parallel processing
    chunk_size = N // num_processes
    chunks = [
        (i * chunk_size, 
         (i+1)*chunk_size if i < num_processes-1 else N,  # Handle remainder
         scalar, A_shm, B_shm, C_shm)
        for i in range(num_processes)
    ]
    
    # Create and start processes
    processes = []
    for chunk in chunks:
        p = mp.Process(target=triad_worker, args=(chunk,))
        processes.append(p)
        p.start()
    
    # Wait for all processes to complete
    for p in processes:
        p.join()
    
    # Verify results (optional)
    A_np = np.frombuffer(A_shm, dtype=np.float64)
    print("First 10 elements of A:", A_np[:10])

if __name__ == '__main__':
    start_time = time.time()
    main()
    print(f"Execution time: {time.time() - start_time:.2f} seconds")
