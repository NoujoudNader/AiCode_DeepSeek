import numpy as np
from scipy.integrate import quad

# Define the function sin(x)
def integrand(x):
    return np.sin(x)

# Define the limits of integration
a = -np.pi
b = (2/3) * np.pi

# Compute the area using numerical integration
area, error = quad(integrand, a, b)

# Print the computed area
print(f"The area between -π and 2/3π for sin(x) is: {area:.6f}")

# Validation: Compute the exact area using the antiderivative of sin(x)
# The antiderivative of sin(x) is -cos(x)
exact_area = -np.cos(b) - (-np.cos(a))

# Print the exact area
print(f"The exact area computed using the antiderivative is: {exact_area:.6f}")

# Compare the numerical and exact results
print(f"Difference between numerical and exact area: {abs(area - exact_area):.6f}")
