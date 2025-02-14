using LinearAlgebra
using Base.Threads

function parallel_matmul(A::Matrix{Float64}, B::Matrix{Float64})
    m, n = size(A)
    p = size(B, 2)
    C = zeros(m, p)
    
    # Parallelize row computation across available threads
    @threads for i in 1:m
        for j in 1:p
            acc = 0.0
            for k in 1:n
                acc += A[i,k] * B[k,j]
            end
            C[i,j] = acc
        end
    end
    return C
end

function validate(C1::Matrix{Float64}, C2::Matrix{Float64}, tol=1e-6)
    return isapprox(C1, C2, atol=tol)
end

# Matrix dimensions
const N = 1024  # Size of N x N matrices

# Generate random matrices
A = rand(N, N)
B = rand(N, N)

# Warmup (JIT compilation)
parallel_matmul(A, B);

# Parallel multiplication
println("Parallel implementation:")
@time C_parallel = parallel_matmul(A, B)

# Built-in multiplication
println("\nBuilt-in multiplication:")
@time C_builtin = A * B

# Validation
if validate(C_parallel, C_builtin)
    println("\nValidation PASSED")
else
    println("\nValidation FAILED")
end

# Performance comparison
println("\nPerformance ratio (built-in/parallel): $(@elapsed(A*B) / $(@elapsed parallel_matmul(A,B))")
