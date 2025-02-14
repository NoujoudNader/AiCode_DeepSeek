using LinearAlgebra

# Define the tridiagonal matrix and vector
A = Tridiagonal([-1.0, -1.0], [4.0, 4.0, 4.0], [-1.0, -1.0])
b = [1.0, 2.0, 3.0]

function conjugate_gradient(A, b; tol=1e-12, max_iter=1000)
    x = zeros(length(b))    # Initial guess
    r = copy(b)             # Initial residual (b - A*0)
    p = copy(r)             # Initial search direction
    rsold = dot(r, r)       # Initial residual squared norm
    
    for iter in 1:max_iter
        Ap = A * p          # Matrix-vector product
        alpha = rsold / dot(p, Ap)
        x .+= alpha .* p    # Update solution
        r .-= alpha .* Ap   # Update residual
        rsnew = dot(r, r)   # New residual norm
        
        # Check convergence
        if sqrt(rsnew) < tol
            println("Converged in $iter iterations")
            break
        end
        
        # Update search direction
        beta = rsnew / rsold
        p .= r .+ beta .* p
        rsold = rsnew
    end
    return x
end

# Solve using Conjugate Gradient
x = conjugate_gradient(A, b)

# Display results
println("\nCG Solution:")
println(x)

# Validate solution
residual = A * x - b
println("\nResidual norm: ", norm(residual))

# Compare with Julia's built-in solver
x_exact = A \ b
println("\nExact solution:")
println(x_exact)

# Calculate error norm
println("\nError norm: ", norm(x - x_exact))
