using Base.Threads
using Plots
using LinearAlgebra
using Printf

function solve_heat_parallel()
    # Parameters
    α = 0.1     # Thermal diffusivity
    L = 100000.0     # Domain length
    n = 1000000     # Spatial points
    h = L / (n - 1)
    T = 0.1     # Total time
    dt = T / 1000
    nt = Int(T / dt)
    
    # Initialize arrays
    x = range(0, L, length=n)
    u_old = sin.(π .* x)
    u_new = similar(u_old)
    
    # Precompute coefficients
    factor = α * dt / h^2
    
    # Time stepping loop with multithreading
    @time for _ in 1:nt
        @threads for i in 2:n-1
            u_new[i] = u_old[i] + factor * (u_old[i+1] - 2u_old[i] + u_old[i-1])
        end
        # Boundary conditions
        u_new[1] = 0.0
        u_new[end] = 0.0
        u_old, u_new = u_new, u_old  # Swap arrays
    end
    
    # Analytical solution
    analytical = exp(-α * π^2 * T) .* sin.(π .* x)
    
    # Calculate L2 error
    l2_error = norm(u_old - analytical) * sqrt(h)
    @printf "L2 Error: %.4e\n" l2_error
    
    # Plot results
    plot(x, u_old, label="Numerical", linewidth=2, xlabel="x", ylabel="u(t, x)", 
         title="1D Heat Equation Solution at t=0.1", legend=:topright)
    plot!(x, analytical, label="Analytical", linestyle=:dash, linewidth=2)
    savefig("heat_equation_julia.png")
end

# Run the solver
solve_heat_parallel()
