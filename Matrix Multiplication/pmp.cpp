#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>
#include <omp.h>

using namespace std;

// Initialize matrix with random values between 0 and 1
void initialize_matrix(vector<vector<double>>& matrix) {
    for (auto& row : matrix) {
        for (auto& element : row) {
            element = static_cast<double>(rand()) / RAND_MAX;
        }
    }
}

// Parallel matrix multiplication using OpenMP
void parallel_matrix_mult(const vector<vector<double>>& A, 
                          const vector<vector<double>>& B, 
                          vector<vector<double>>& C) {
    int N = A.size();
    int K = B.size();
    int M = B[0].size();

    #pragma omp parallel for
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < M; ++j) {
            C[i][j] = 0.0;
            for (int k = 0; k < K; ++k) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Sequential matrix multiplication for validation
void sequential_matrix_mult(const vector<vector<double>>& A, 
                            const vector<vector<double>>& B, 
                            vector<vector<double>>& C) {
    int N = A.size();
    int K = B.size();
    int M = B[0].size();

    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < M; ++j) {
            C[i][j] = 0.0;
            for (int k = 0; k < K; ++k) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Compare two matrices with given tolerance
bool validate_result(const vector<vector<double>>& C1, 
                     const vector<vector<double>>& C2, 
                     double epsilon = 1e-6) {
    if (C1.size() != C2.size() || C1[0].size() != C2[0].size()) {
        return false;
    }

    for (size_t i = 0; i < C1.size(); ++i) {
        for (size_t j = 0; j < C1[0].size(); ++j) {
            if (fabs(C1[i][j] - C2[i][j]) > epsilon) {
                cout << "Mismatch at (" << i << "," << j << "): "
                     << C1[i][j] << " vs " << C2[i][j] << endl;
                return false;
            }
        }
    }
    return true;
}

int main() {
    const int N = 512;  // Rows of A and C
    const int K = 512;  // Columns of A and rows of B
    const int M = 512;  // Columns of B and C

    // Initialize matrices
    vector<vector<double>> A(N, vector<double>(K));
    vector<vector<double>> B(K, vector<double>(M));
    vector<vector<double>> C_par(N, vector<double>(M));
    vector<vector<double>> C_seq(N, vector<double>(M));

    srand(42);  // Fixed seed for reproducibility
    initialize_matrix(A);
    initialize_matrix(B);

    // Perform parallel multiplication
    double start = omp_get_wtime();
    parallel_matrix_mult(A, B, C_par);
    double par_time = omp_get_wtime() - start;
    cout << "Parallel time: " << par_time << " seconds\n";

    // Perform sequential multiplication
    start = omp_get_wtime();
    sequential_matrix_mult(A, B, C_seq);
    double seq_time = omp_get_wtime() - start;
    cout << "Sequential time: " << seq_time << " seconds\n";

    // Validate results
    if (validate_result(C_par, C_seq)) {
        cout << "Validation PASSED\n";
    } else {
        cout << "Validation FAILED\n";
    }

    cout << "Speedup: " << seq_time / par_time << endl;

    return 0;
}
