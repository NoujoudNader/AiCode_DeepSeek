library(foreach)
library(doParallel)
library(ggplot2)

# Parameters
alpha <- 0.1
L <- 1.0
n <- 100
h <- L / (n - 1)
T_total <- 0.1
dt <- T_total / 1000
nt <- as.integer(T_total / dt)

# Spatial grid
x <- seq(0, L, length.out = n)

# Initialize solution matrix with boundary conditions
u_old <- sin(pi * x)
u_old[1] <- 0    # Left boundary
u_old[n] <- 0    # Right boundary

# Setup parallel backend
cores <- detectCores()
cl <- makeCluster(cores)
registerDoParallel(cl)

# Time integration using Euler method
system.time({
    for (t in 1:nt) {
        u_new <- u_old  # Copy previous state
        
        # Parallel computation of interior points
        interior <- 2:(n-1)
        updates <- foreach(i = interior, .combine = c) %dopar% {
            u_old[i] + alpha * dt * (u_old[i+1] - 2*u_old[i] + u_old[i-1]) / h^2
        }
        
        u_new[interior] <- updates
        u_old <- u_new  # Update for next iteration
    }
})

# Stop parallel cluster
stopCluster(cl)

# Analytical solution
analytical <- exp(-alpha * pi^2 * T_total) * sin(pi * x)

# Create data frame for plotting
results <- data.frame(
    x = x,
    Numerical = u_old,
    Analytical = analytical
)

# Plot results
ggplot(results, aes(x = x)) +
    geom_line(aes(y = Numerical, color = "Numerical"), linewidth = 1) +
    geom_line(aes(y = Analytical, color = "Analytical"), linetype = "dashed", linewidth = 1) +
    scale_color_manual(values = c("Numerical" = "blue", "Analytical" = "red")) +
    labs(title = "1D Heat Equation Solution at t=0.1",
         x = "Position x",
         y = "Temperature u(t, x)",
         color = "Solution Type") +
    theme_minimal() +
    theme(legend.position = "top")

# Calculate L2 error
l2_error <- sqrt(sum((u_old - analytical)^2) * h)
cat(sprintf("L2 Error: %.4e\n", l2_error))
