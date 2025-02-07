#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

// Matrix-vector multiplication for tridiagonal matrix A
void mat_vec(const vector<double>& p, vector<double>& Ap) {
    int n = p.size();
    Ap.resize(n);
    if (n == 0) return;
    Ap[0] = 4.0 * p[0] - p[1];
    for (int i = 1; i < n-1; ++i) {
        Ap[i] = -p[i-1] + 4.0 * p[i] - p[i+1];
    }
    if (n > 1) {
        Ap[n-1] = -p[n-2] + 4.0 * p[n-1];
    }
}

// Dot product of two vectors
double dot_product(const vector<double>& a, const vector<double>& b) {
    double result = 0.0;
    for (size_t i = 0; i < a.size(); ++i) {
        result += a[i] * b[i];
    }
    return result;
}

// Conjugate Gradient solver
vector<double> conjugate_gradient(const vector<double>& b, double tol=1e-6, int max_iter=1000) {
    int n = b.size();
    vector<double> x(n, 0.0); // Initial guess
    vector<double> r = b;     // Initial residual (b - A*0)
    vector<double> p = r;     // Initial search direction
    double rsold = dot_product(r, r);
    
    for (int iter = 0; iter < max_iter; ++iter) {
        vector<double> Ap;
        mat_vec(p, Ap);
        double alpha = rsold / dot_product(p, Ap);
        // Update solution and residual
        for (int i = 0; i < n; ++i) {
            x[i] += alpha * p[i];
            r[i] -= alpha * Ap[i];
        }
        double rsnew = dot_product(r, r);
        // Check convergence
        if (sqrt(rsnew) < tol) {
            cout << "Converged in " << iter+1 << " iterations" << endl;
            break;
        }
        // Update search direction
        double beta = rsnew / rsold;
        for (int i = 0; i < n; ++i) {
            p[i] = r[i] + beta * p[i];
        }
        rsold = rsnew;
    }
    return x;
}

int main() {
    vector<double> b = {1.0, 2.0, 3.0};
    
    // Solve using Conjugate Gradient
    vector<double> x = conjugate_gradient(b);
    
    // Display solution
    cout << "CG Solution: ";
    for (double xi : x) {
        cout << xi << " ";
    }
    cout << endl;
    
    // Compute residual A*x - b
    vector<double> Ax;
    mat_vec(x, Ax);
    vector<double> residual(3);
    for (int i = 0; i < 3; ++i) {
        residual[i] = Ax[i] - b[i];
    }
    cout << "Residual vector: ";
    for (double r : residual) {
        cout << r << " ";
    }
    cout << "\nResidual norm: " << sqrt(dot_product(residual, residual)) << endl;
    
    // Exact solution using Cramer's rule
    vector<double> x_exact = {13.0/28, 6.0/7, 27.0/28};
    cout << "Exact solution: ";
    for (double xi : x_exact) {
        cout << xi << " ";
    }
    cout << endl;
    
    // Compute error norm
    vector<double> error(3);
    for (int i = 0; i < 3; ++i) {
        error[i] = x[i] - x_exact[i];
    }
    cout << "Error norm: " << sqrt(dot_product(error, error)) << endl;
    
    return 0;
}
