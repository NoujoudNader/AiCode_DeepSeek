import numpy as np
import matplotlib.pyplot as plt
from numba import njit, prange
import time

# Parameters
alpha = 0.1   # Thermal diffusivity
L = 100000.0      # Length of the domain
n = 10000000       # Number of spatial points
h = L / (n - 1)  # Spatial step size
T = 0.1       # Total simulation time
dt = T / 1000 # Time step size
nt = 1000  # Number of time steps

# Spatial grid
x = np.linspace(0, L, n)
# Initial condition
u0 = np.sin(np.pi * x)

@njit(parallel=True)
def solve_heat(u, nt, dt, h, alpha):
    """
    Solve the 1D heat equation using finite differences and Euler method.
    Parallel implementation using Numba.
    """
    n = u.shape[0]
    u_new = np.empty_like(u)
    for _ in range(nt):
        for i in prange(n):
            if i == 0 or i == n-1:
                u_new[i] = 0.0  # Dirichlet boundary conditions
            else:
                # Finite difference scheme
                laplacian = (u[i+1] - 2*u[i] + u[i-1]) / h**2
                u_new[i] = u[i] + alpha * dt * laplacian
        u[:] = u_new[:]  # Update for next iteration
    return u

# Solve the heat equation
u_numerical = u0.copy()
start_time = time.perf_counter()
u_numerical = solve_heat(u_numerical, nt, dt, h, alpha)
end_time = time.perf_counter()
elapsed_time = end_time - start_time
print(elapsed_time)

# Analytical solution
t_final = T
analytical = np.exp(-alpha * np.pi**2 * t_final) * np.sin(np.pi * x)

# Plotting results
plt.figure(figsize=(10, 6))
plt.plot(x, u_numerical, label='Numerical Solution', linewidth=2)
plt.plot(x, analytical, '--', label='Analytical Solution', linewidth=2)
plt.xlabel('x', fontsize=12)
plt.ylabel('u(t, x)', fontsize=12)
plt.legend(fontsize=12)
plt.title('1D Heat Equation Solution at t=0.1', fontsize=14)
plt.grid(True)
plt.show()

# Calculate and print L2 error
error = np.sqrt(h * np.sum((u_numerical - analytical)**2))
#print(f"L2 Error: {error:.6e}")
