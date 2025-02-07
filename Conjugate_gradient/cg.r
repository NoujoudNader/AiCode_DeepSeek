conjugate_gradient <- function(A, b, tol = 1e-6, max_iter = 1000) {
  n <- length(b)
  x <- numeric(n)  # Initial guess (0,0,0)
  r <- b - A %*% x  # Initial residual
  p <- r  # Initial search direction
  rsold <- crossprod(r)  # r^T r (crossprod is more efficient)
  
  for (iter in 1:max_iter) {
    Ap <- A %*% p  # Matrix-vector product
    alpha <- as.numeric(rsold / crossprod(p, Ap))  # Step size
    x <- x + alpha * p  # Update solution
    r <- r - alpha * Ap  # Update residual
    rsnew <- crossprod(r)  # New residual norm
    
    # Check convergence
    if (sqrt(rsnew) < tol) {
      cat(sprintf("Converged in %d iterations\n", iter))
      break
    }
    
    # Update search direction
    beta <- as.numeric(rsnew / rsold)
    p <- r + beta * p
    rsold <- rsnew
  }
  
  if (sqrt(rsnew) >= tol) {
    cat(sprintf("Did not converge in %d iterations\n", max_iter))
  }
  
  return(x)
}

# Define matrix A and vector b
A <- matrix(c(4, -1, 0,
              -1, 4, -1,
              0, -1, 4), nrow = 3, byrow = TRUE)
b <- c(1, 2, 3)

# Solve using Conjugate Gradient
x <- conjugate_gradient(A, b)

# Display solution
cat("\nCG Solution:\n")
print(x)

# Validate solution
residual <- A %*% x - b
residual_norm <- norm(residual, "2")
cat(sprintf("\nResidual norm: %.2e\n", residual_norm))

# Compare with exact solution
x_exact <- solve(A, b)
cat("Exact solution (solve(A, b)):\n")
print(x_exact)

# Calculate error norm
error_norm <- norm(x - x_exact, "2")
cat(sprintf("\nError norm: %.2e\n", error_norm))
