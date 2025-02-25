using Base.Threads
using LinearAlgebra
using BenchmarkTools

function naive_dgemm!(C, A, B)
    N = size(A, 1)
    @threads for i in 1:N
        for j in 1:N
            acc = 0.0
            for k in 1:N
                @inbounds acc += A[i, k] * B[k, j]
            end
            @inbounds C[i, j] = acc
        end
    end
    return C
end

function optimized_dgemm!(C, A, B, block_size)
    N = size(A, 1)
    Bt = transpose(B)
    fill!(C, 0.0)
    
    @threads for ii in 1:block_size:N
        i_end = min(ii + block_size - 1, N)
        for jj in 1:block_size:N
            j_end = min(jj + block_size - 1, N)
            for kk in 1:block_size:N
                k_end = min(kk + block_size - 1, N)
                for i in ii:i_end
                    for j in jj:j_end
                        acc = 0.0
                        @inbounds @simd for k in kk:k_end
                            acc += A[i, k] * Bt[j, k]
                        end
                        @inbounds C[i, j] += acc
                    end
                end
            end
        end
    end
    return C
end

function validate(C1, C2; atol=1e-6)
    return isapprox(C1, C2; atol=atol)
end

function benchmark()
    sizes = [512, 1024, 2048]
    blocks = [32, 64, 128]
    println("| Size | Block | Method    | Time (s) | GFLOPS  | Valid |")
    println("|------|-------|-----------|----------|---------|-------|")
    
    for n in sizes
        println(n)
        A = rand(n, n)
        B = rand(n, n)
        C_ref = A * B
        C_naive = similar(A)
        C_opt = similar(A)
        
        # Benchmark BLAS
        blas_time = @belapsed $A * $B
        blas_gflops = 2n^3 / blas_time / 1e9
        println("| $n | - | BLAS | $(round(blas_time, digits=4)) | $(round(blas_gflops, digits=2)) | true |")
        
        # Benchmark optimized versions
        for bs in blocks
            opt_time = @belapsed optimized_dgemm!($C_opt, $A, $B, $bs)
            opt_gflops = 2n^3 / opt_time / 1e9
            valid = validate(C_opt, C_ref)
            println("| $n | $bs | Optimized | $(round(opt_time, digits=4)) | $(round(opt_gflops, digits=2)) | $valid |")
            fill!(C_opt, 0.0)
        end
        println(n)
        # Benchmark naive implementation
        if n <= 1024
            naive_time = @belapsed naive_dgemm!($C_naive, $A, $B)
            naive_gflops = 2n^3 / naive_time / 1e9
            valid = validate(C_naive, C_ref)
            println("| $n | - | Naive | $(round(naive_time, digits=4)) | $(round(naive_gflops, digits=2)) | $valid |")
        end
    end
end

# Run benchmark comparison
benchmark()
