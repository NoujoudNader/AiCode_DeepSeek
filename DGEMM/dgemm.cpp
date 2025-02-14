#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <omp.h>

void transpose_matrix(const double* B, double* Bt, int N) {
    #pragma omp parallel for
    for (int j = 0; j < N; ++j) {
        for (int k = 0; k < N; ++k) {
            Bt[j * N + k] = B[k * N + j];
        }
    }
}

void dgemm_parallel(double alpha, const double* A, const double* B, double beta, double* C, int N, int block_size) {
    // Scale C by beta
    #pragma omp parallel for
    for (int i = 0; i < N * N; ++i) {
        C[i] *= beta;
    }

    // Transpose B
    std::vector<double> Bt(N * N);
    transpose_matrix(B, Bt.data(), N);

    // Compute C += alpha * A * B using blocked and transposed B
    #pragma omp parallel for
    for (int ii = 0; ii < N; ii += block_size) {
        int i_end = std::min(ii + block_size, N);
        for (int jj = 0; jj < N; jj += block_size) {
            int j_end = std::min(jj + block_size, N);
            for (int kk = 0; kk < N; kk += block_size) {
                int k_end = std::min(kk + block_size, N);
                for (int i = ii; i < i_end; ++i) {
                    for (int j = jj; j < j_end; ++j) {
                        double sum = 0.0;
                        for (int k = kk; k < k_end; ++k) {
                            sum += A[i * N + k] * Bt[j * N + k];
                        }
                        C[i * N + j] += alpha * sum;
                    }
                }
            }
        }
    }
}

void dgemm_naive(double alpha, const double* A, const double* B, double beta, double* C, int N) {
    #pragma omp parallel for
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            double sum = 0.0;
            for (int k = 0; k < N; ++k) {
                sum += A[i * N + k] * B[k * N + j];
            }
            C[i * N + j] = alpha * sum + beta * C[i * N + j];
        }
    }
}

bool validate(const double* C1, const double* C2, int N, double tolerance = 1e-6) {
    for (int i = 0; i < N * N; ++i) {
        if (std::abs(C1[i] - C2[i]) > tolerance) {
            std::cerr << "Validation failed at index " << i << ": " << C1[i] << " vs " << C2[i] << std::endl;
            return false;
        }
    }
    return true;
}

int main(int argc, char** argv) {
    int N = 1024;
    if (argc > 1) {
        N = std::atoi(argv[1]);
    }

    int block_size = 64;
    if (argc > 2) {
        block_size = std::atoi(argv[2]);
    }

    std::vector<double> A(N * N);
    std::vector<double> B(N * N);
    std::vector<double> C_parallel(N * N, 0.0);
    std::vector<double> C_naive(N * N, 0.0);

    // Initialize A and B with random values
    #pragma omp parallel for
    for (int i = 0; i < N * N; ++i) {
        A[i] = static_cast<double>(rand()) / RAND_MAX;
        B[i] = static_cast<double>(rand()) / RAND_MAX;
    }

    // Test parameters
    double alpha = 1.0;
    double beta = 0.0;

    // Run parallel DGEMM
    auto start = std::chrono::high_resolution_clock::now();
    dgemm_parallel(alpha, A.data(), B.data(), beta, C_parallel.data(), N, block_size);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> parallel_time = end - start;
    double parallel_flops = 2.0 * N * N * N / parallel_time.count() / 1e9; // GFLOP/s

    // Run naive DGEMM
    start = std::chrono::high_resolution_clock::now();
    dgemm_naive(alpha, A.data(), B.data(), beta, C_naive.data(), N);
    end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> naive_time = end - start;
    double naive_flops = 2.0 * N * N * N / naive_time.count() / 1e9;

    // Validate
    bool valid = validate(C_parallel.data(), C_naive.data(), N);

    std::cout << "Matrix size: " << N << "x" << N << std::endl;
    std::cout << "Block size: " << block_size << std::endl;
    std::cout << "Parallel time: " << parallel_time.count() << " s, GFLOP/s: " << parallel_flops << std::endl;
    std::cout << "Naive time: " << naive_time.count() << " s, GFLOP/s: " << naive_flops << std::endl;
    std::cout << "Validation: " << (valid ? "PASSED" : "FAILED") << std::endl;

    return 0;
}
