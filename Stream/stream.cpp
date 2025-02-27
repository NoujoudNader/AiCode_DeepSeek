#include <iostream>
#include <vector>
#include <omp.h>
#include <chrono>
#include <memory>

void stream_triad(double* __restrict a,
                  const double* __restrict b,
                  const double* __restrict c,
                  const double scalar,
                  const size_t n) {
    #pragma omp parallel for simd aligned(a, b, c: 64)
    for (size_t i = 0; i < n; ++i) {
        a[i] = b[i] + scalar * c[i];
    }
}

int main() {
    const size_t N = 1UL << 27; // 134,217,728 elements (~1GB per array)
    const double scalar = 3.0;
    const int num_threads = omp_get_max_threads();
    
    // Allocate aligned memory
    auto align_alloc = [](size_t size) {
        return std::unique_ptr<double[], void(*)(double*)>(
            static_cast<double*>(aligned_alloc(64, size * sizeof(double))),
            [](double* p) { free(p); });
    };
    
    auto a = align_alloc(N);
    auto b = align_alloc(N);
    auto c = align_alloc(N);

    auto b_p = b.get();
    auto c_p = c.get();
    // Initialize arrays in parallel
    #pragma omp parallel for simd aligned(b_p, c_p: 64)
    for (size_t i = 0; i < N; ++i) {
        b[i] = 1.0;
        c[i] = 2.0;
    }

    // Warm-up run
    stream_triad(a.get(), b.get(), c.get(), scalar, N);

    // Timed run
    const auto start = std::chrono::high_resolution_clock::now();
    stream_triad(a.get(), b.get(), c.get(), scalar, N);
    const auto end = std::chrono::high_resolution_clock::now();

    // Calculate bandwidth
    const double time = std::chrono::duration<double>(end - start).count();
    const double bytes_accessed = 3 * N * sizeof(double);
    const double bandwidth = (bytes_accessed / time) / (1 << 30); // GB/s

    std::cout << "STREAM Triad Benchmark\n"
              << "Array size: " << N << " elements (" << N*sizeof(double)/1e6 << " MB each)\n"
              << "Threads: " << num_threads << "\n"
              << "Time: " << time << " seconds\n"
              << "Bandwidth: " << bandwidth << " GB/s\n"
              << "First 3 elements: [" << a[0] << ", " << a[1] << ", " << a[2] << "]\n";

    return 0;
}
