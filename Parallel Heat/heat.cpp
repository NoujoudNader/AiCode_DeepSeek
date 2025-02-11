#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <omp.h>

int main() {
    // Parameters
    const double alpha = 0.1;
    const double L = 1.0;
    const int n = 100;
    const double h = L / (n - 1);
    const double T = 0.1;
    const double dt = T / 1000;
    const int nt = 1000;
    const double factor = alpha * dt / (h * h);

    // Initialize vectors
    std::vector<double> x(n), u_old(n), u_new(n), analytical(n);
    
    // Set initial condition
    #pragma omp parallel for
    for (int i = 0; i < n; ++i) {
        x[i] = i * h;
        u_old[i] = sin(M_PI * x[i]);
    }
    u_old[0] = u_old[n-1] = 0.0;  // Boundary conditions

    // Time-stepping loop
    double start_time = omp_get_wtime();
    for (int t = 0; t < nt; ++t) {
        #pragma omp parallel for
        for (int i = 1; i < n-1; ++i) {
            u_new[i] = u_old[i] + factor * 
                      (u_old[i+1] - 2*u_old[i] + u_old[i-1]);
        }
        
        // Apply boundary conditions and swap arrays
        u_new[0] = 0.0;
        u_new[n-1] = 0.0;
        std::swap(u_old, u_new);
    }
    double end_time = omp_get_wtime();

    // Analytical solution
    const double exp_factor = exp(-alpha * M_PI * M_PI * T);
    #pragma omp parallel for
    for (int i = 0; i < n; ++i) {
        analytical[i] = exp_factor * sin(M_PI * x[i]);
    }

    // Calculate L2 error
    double l2_error = 0.0;
    for (int i = 0; i < n; ++i) {
        double diff = u_old[i] - analytical[i];
        l2_error += diff * diff;
    }
    l2_error = sqrt(h * l2_error);
    
    // Output results
    std::cout << "Computation time: " << end_time - start_time << "s\n";
    std::cout << "L2 Error: " << l2_error << "\n";

    // Write data to file
    std::ofstream outfile("results.csv");
    outfile << "x,Numerical,Analytical\n";
    for (int i = 0; i < n; ++i) {
        outfile << x[i] << "," << u_old[i] << "," << analytical[i] << "\n";
    }
    outfile.close();

    return 0;
}
