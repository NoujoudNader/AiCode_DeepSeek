public class ComputeArea {
    // Function to compute sin(x)
    public static double integrand(double x) {
        return Math.sin(x);
    }

    // Function to compute the area using the trapezoidal rule
    public static double trapezoidalRule(double a, double b, int n) {
        double h = (b - a) / n; // Step size
        double sum = 0.5 * (integrand(a) + integrand(b)); // First and last terms

        for (int i = 1; i < n; i++) {
            double x = a + i * h;
            sum += integrand(x);
        }

        return sum * h;
    }

    public static void main(String[] args) {
        // Define the limits of integration
        double a = -Math.PI; // -π
        double b = (2.0 / 3.0) * Math.PI; // 2/3π

        // Number of intervals for the trapezoidal rule
        int n = 1000; // Increase for better accuracy

        // Compute the area using the trapezoidal rule
        double area = trapezoidalRule(a, b, n);

        // Print the computed area
        System.out.printf("The area between -π and 2/3π for sin(x) is: %.6f%n", area);

        // Validation: Compute the exact area using the antiderivative of sin(x)
        // The antiderivative of sin(x) is -cos(x)
        double exactArea = (-Math.cos(b)) - (-Math.cos(a));

        // Print the exact area
        System.out.printf("The exact area computed using the antiderivative is: %.6f%n", exactArea);

        // Compare the numerical and exact results
        double difference = Math.abs(area - exactArea);
        System.out.printf("Difference between numerical and exact area: %.6f%n", difference);
    }
}
