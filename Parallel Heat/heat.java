import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;

public class HeatEquation {

    public static void main(String[] args) {
        // Parameters
        final double alpha = 0.1;
        final double L = 1.0;
        final int n = 100;
        final double h = L / (n - 1);
        final double T = 0.1;
        final double dt = T / 1000;
        final int nt = 1000;
        final double factor = alpha * dt / (h * h);
        final int threshold = 25;

        // Initialize arrays
        double[] current = new double[n];
        double[] next = new double[n];
        for (int j = 0; j < n; j++) {
            double x = j * h;
            current[j] = Math.sin(Math.PI * x);
        }

        ForkJoinPool pool = new ForkJoinPool();

        // Time-stepping loop
        for (int t = 0; t < nt; t++) {
            next[0] = 0.0;      // Left boundary
            next[n-1] = 0.0;    // Right boundary
            
            pool.invoke(new HeatTask(current, next, 1, n-2, threshold, factor));
            
            // Swap arrays for next iteration
            double[] temp = current;
            current = next;
            next = temp;
        }

        // Compute analytical solution
        double[] analytical = new double[n];
        double tFinal = T;
        double expFactor = Math.exp(-alpha * Math.PI * Math.PI * tFinal);
        for (int j = 0; j < n; j++) {
            analytical[j] = expFactor * Math.sin(Math.PI * j * h);
        }

        // Calculate and print L2 error
        double errorSq = 0.0;
        for (int j = 0; j < n; j++) {
            double diff = current[j] - analytical[j];
            errorSq += diff * diff;
        }
        double l2Error = Math.sqrt(h * errorSq);
        System.out.printf("L2 Error: %.6e\n", l2Error);

        // Output results for plotting
        for (int j = 0; j < n; j++) {
            System.out.printf("%f,%f,%f\n", j*h, current[j], analytical[j]);
        }
    }

    static class HeatTask extends RecursiveAction {
        private final double[] uOld;
        private final double[] uNew;
        private final int start, end, threshold;
        private final double alphaDtOverH2;

        public HeatTask(double[] uOld, double[] uNew, int start, int end, 
                       int threshold, double factor) {
            this.uOld = uOld;
            this.uNew = uNew;
            this.start = start;
            this.end = end;
            this.threshold = threshold;
            this.alphaDtOverH2 = factor;
        }

        @Override
        protected void compute() {
            if (end - start < threshold) {
                for (int i = start; i <= end; i++) {
                    uNew[i] = uOld[i] + alphaDtOverH2 * 
                             (uOld[i+1] - 2*uOld[i] + uOld[i-1]);
                }
            } else {
                int mid = (start + end) / 2;
                invokeAll(
                    new HeatTask(uOld, uNew, start, mid, threshold, alphaDtOverH2),
                    new HeatTask(uOld, uNew, mid+1, end, threshold, alphaDtOverH2)
                );
            }
        }
    }
}
