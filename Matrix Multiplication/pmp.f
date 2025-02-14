program parallel_matmul
    use omp_lib
    implicit none
    integer, parameter :: N = 512       ! Matrix dimension
    integer, parameter :: dp = kind(1.d0)
    real(dp), parameter :: tolerance = 1.0e-10_dp
    
    real(dp), allocatable :: A(:,:), B(:,:), C_par(:,:), C_seq(:,:)
    integer :: i, j, k
    real(dp) :: start_time, end_time, max_diff
    integer :: seed_size, clock
    integer, allocatable :: seed(:)
    
    ! Initialize random seed for reproducibility
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    call system_clock(count=clock)
    seed = clock + 37 * [(i, i=0,seed_size-1)]
    call random_seed(put=seed)
    deallocate(seed)
    
    ! Allocate matrices
    allocate(A(N,N), B(N,N), C_par(N,N), C_seq(N,N))
    
    ! Initialize matrices with random values
    call random_number(A)
    call random_number(B)
    
    ! Sequential matrix multiplication
    start_time = omp_get_wtime()
    do i = 1, N
        do j = 1, N
            C_seq(i,j) = 0.0_dp
            do k = 1, N
                C_seq(i,j) = C_seq(i,j) + A(i,k) * B(k,j)
            end do
        end do
    end do
    end_time = omp_get_wtime()
    print '(A,F8.4,A)', 'Sequential time: ', end_time - start_time, ' s'
    
    ! Parallel matrix multiplication using OpenMP
    start_time = omp_get_wtime()
    !$OMP PARALLEL DO PRIVATE(i,j,k) SHARED(A,B,C_par) SCHEDULE(static)
    do i = 1, N
        do j = 1, N
            C_par(i,j) = 0.0_dp
            do k = 1, N
                C_par(i,j) = C_par(i,j) + A(i,k) * B(k,j)
            end do
        end do
    end do
    !$OMP END PARALLEL DO
    end_time = omp_get_wtime()
    print '(A,F8.4,A)', 'Parallel time:   ', end_time - start_time, ' s'
    
    ! Validation
    max_diff = 0.0_dp
    do concurrent (i = 1:N, j = 1:N)
        max_diff = max(max_diff, abs(C_par(i,j) - C_seq(i,j)))
    end do
    
    if (max_diff < tolerance) then
        print '(A)', 'Validation PASSED'
    else
        print '(A,E10.3)', 'Validation FAILED. Maximum difference: ', max_diff
    end if
    
    print '(A,F5.2)', 'Speedup ratio: ', (end_time - start_time) / &
                      (omp_get_wtime() - start_time)
    
    deallocate(A, B, C_par, C_seq)
end program parallel_matmul
