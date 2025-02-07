public class ConjugateGradientSolver {

    public static void main(String[] args) {
        double[] b = {1.0, 2.0, 3.0};
        double[] x = solve(b, 1e-12, 1000);

        System.out.println("CG Solution:");
        printVector(x);

        // Compute residual A*x - b
        double[] Ax = matrixVectorMultiply(x);
        double[] residual = vectorSubtract(Ax, b);
        System.out.printf("Residual norm: %.2e\n", norm(residual));

        // Exact solution (precomputed)
        double[] xExact = {13.0/28, 6.0/7, 27.0/28};
        System.out.println("Exact solution:");
        printVector(xExact);

        // Compute error
        double[] error = vectorSubtract(x, xExact);
        System.out.printf("Error norm: %.2e\n", norm(error));
    }

    public static double[] solve(double[] b, double tol, int maxIter) {
        int n = b.length;
        double[] x = new double[n];
        double[] r = b.clone();
        double[] p = r.clone();
        double rsold = dotProduct(r, r);

        for (int iter = 0; iter < maxIter; iter++) {
            double[] Ap = matrixVectorMultiply(p);
            double alpha = rsold / dotProduct(p, Ap);

            // Update solution and residual
            x = vectorAdd(x, vectorScale(p, alpha));
            r = vectorSubtract(r, vectorScale(Ap, alpha));

            double rsnew = dotProduct(r, r);
            if (Math.sqrt(rsnew) < tol) {
                System.out.printf("Converged in %d iterations\n", iter+1);
                break;
            }

            double beta = rsnew / rsold;
            p = vectorAdd(r, vectorScale(p, beta));
            rsold = rsnew;
        }
        return x;
    }

    // Tridiagonal matrix-vector multiplication (specific to our 3x3 matrix)
    private static double[] matrixVectorMultiply(double[] p) {
        return new double[] {
            4*p[0] - p[1],
            -p[0] + 4*p[1] - p[2],
            -p[1] + 4*p[2]
        };
    }

    // Helper functions for linear algebra operations
    private static double dotProduct(double[] a, double[] b) {
        double sum = 0.0;
        for (int i = 0; i < a.length; i++) {
            sum += a[i] * b[i];
        }
        return sum;
    }

    private static double[] vectorAdd(double[] a, double[] b) {
        double[] result = new double[a.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i] + b[i];
        }
        return result;
    }

    private static double[] vectorSubtract(double[] a, double[] b) {
        double[] result = new double[a.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i] - b[i];
        }
        return result;
    }

    private static double[] vectorScale(double[] v, double scalar) {
        double[] result = new double[v.length];
        for (int i = 0; i < v.length; i++) {
            result[i] = v[i] * scalar;
        }
        return result;
    }

    private static double norm(double[] v) {
        return Math.sqrt(dotProduct(v, v));
    }

    private static void printVector(double[] v) {
        for (double d : v) {
            System.out.printf("%.12f ", d);
        }
        System.out.println();
    }
}
