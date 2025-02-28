using Base.Threads

function stream_triad!(A, B, C, scalar)
    n = length(A)
    nthread = nthreads()
    chunksize = div(n, nthread)
    
    @threads for tid in 1:nthread
        start = (tid-1)*chunksize + 1
        stop = tid == nthread ? n : tid*chunksize
        @inbounds @simd for i in start:stop
            A[i] = B[i] + scalar * C[i]
        end
    end
end

function main()
    # Configuration
    N = 10^8  # ~763 MB per array (Float64)
    scalar = 3.0
    trials = 5
    
    # Allocate arrays
    A = Vector{Float64}(undef, N)
    B = Vector{Float64}(undef, N)
    C = Vector{Float64}(undef, N)
    
    # Parallel initialization
    @threads for i in eachindex(B, C)
        @inbounds B[i] = 1.0
        @inbounds C[i] = 2.0
    end
    
    # Warm-up and validation
    stream_triad!(A, B, C, scalar)
    @assert A[1] == 7.0 "Validation failed"
    
    # Benchmark
    times = Float64[]
    for _ in 1:trials
        t = @elapsed stream_triad!(A, B, C, scalar)
        push!(times, t)
    end
    
    # Calculate statistics
    avg_time = sum(times) / trials
    bandwidth = (3 * sizeof(Float64) * N) / avg_time / 1e9  # GB/s
    
    # Print results
    println("STREAM Triad Benchmark")
    println("Array size: ", N, " elements (", N*sizeof(Float64)/1e6, " MB each)")
    println("Threads: ", nthreads())
    println("Average time: ", round(avg_time, digits=5), " s")
    println("Bandwidth: ", round(bandwidth, digits=2), " GB/s")
    println("First element: ", A[1])
end

main()
