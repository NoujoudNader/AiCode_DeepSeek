#include <iostream>
#include <cmath>

// Function to compute sin(x)
double integrand(double x) {
    return sin(x);
}

// Function to compute the area using the trapezoidal rule
double trapezoidal_rule(double a, double b, int n) {
    double h = (b - a) / n; // Step size
    double area = 0.5 * (integrand(a) + integrand(b)); // First and last terms

    for (int i = 1; i < n; ++i) {
        double x = a + i * h;
        area += integrand(x);
    }

    area *= h;
    return area;
}

int main() {
    // Define the limits of integration
    double a = -M_PI; // -π
    double b = (2.0 / 3.0) * M_PI; // 2/3π

    // Number of intervals for the trapezoidal rule
    int n = 1000; // Increase for better accuracy

    // Compute the area using the trapezoidal rule
    double area = trapezoidal_rule(a, b, n);

    // Print the computed area
    std::cout << "The area between -π and 2/3π for sin(x) is: " << area << std::endl;

    // Validation: Compute the exact area using the antiderivative of sin(x)
    // The antiderivative of sin(x) is -cos(x)
    double exact_area = (-cos(b)) - (-cos(a));

    // Print the exact area
    std::cout << "The exact area computed using the antiderivative is: " << exact_area << std::endl;

    // Compare the numerical and exact results
    double difference = abs(area - exact_area);
    std::cout << "Difference between numerical and exact area: " << difference << std::endl;

    return 0;
}
