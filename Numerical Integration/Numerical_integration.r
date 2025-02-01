# Define the function sin(x)
integrand <- function(x) {
  sin(x)
}

# Define the limits of integration
a <- -pi
b <- (2/3) * pi

# Compute the area using numerical integration
result <- integrate(integrand, lower = a, upper = b)

# Extract the computed area
area <- result$value

# Print the computed area
cat("The area between -π and 2/3π for sin(x) is:", area, "\n")

# Validation: Compute the exact area using the antiderivative of sin(x)
# The antiderivative of sin(x) is -cos(x)
exact_area <- (-cos(b)) - (-cos(a))

# Print the exact area
cat("The exact area computed using the antiderivative is:", exact_area, "\n")

# Compare the numerical and exact results
difference <- abs(area - exact_area)
cat("Difference between numerical and exact area:", difference, "\n")
