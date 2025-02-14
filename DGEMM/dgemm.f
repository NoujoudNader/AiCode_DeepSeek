module dgemm_mod
    use omp_lib
    implicit none
contains

! Naive DGEMM implementation
subroutine dgemm_naive(A, B, C)
    real(8), intent(in) :: A(:,:), B(:,:)
    real(8), intent(inout) :: C(:,:)
    integer :: n, i, j, k
    n = size(A, 1)
    C = 0.0d0
    !$OMP PARALLEL DO PRIVATE(j,k,i)
    do j = 1, n
        do k = 1, n
            do i = 1, n
                C(i,j) = C(i,j) + A(i,k) * B(k,j)
            end do
        end do
    end do
    !$OMP END PARALLEL DO
end subroutine dgemm_naive

! Optimized DGEMM with cache blocking and OpenMP
subroutine dgemm_optimized(A, B, C, block_size)
    real(8), intent(in) :: A(:,:), B(:,:)
    real(8), intent(inout) :: C(:,:)
    integer, intent(in) :: block_size
    integer :: n, ii, jj, kk, i, j, k
    integer :: i_end, j_end, k_end
    
    n = size(A, 1)
    C = 0.0d0
    
    !$OMP PARALLEL PRIVATE(ii, jj, kk, i_end, j_end, k_end, i, j, k)
    !$OMP DO COLLAPSE(2)
    do jj = 1, n, block_size
        do kk = 1, n, block_size
            j_end = min(jj + block_size - 1, n)
            k_end = min(kk + block_size - 1, n)
            do ii = 1, n, block_size
                i_end = min(ii + block_size - 1, n)
                
                ! Process block
                do j = jj, j_end
                    do k = kk, k_end
                        do i = ii, i_end
                            C(i,j) = C(i,j) + A(i,k) * B(k,j)
                        end do
                    end do
                end do
            end do
        end do
    end do
    !$OMP END DO
    !$OMP END PARALLEL
end subroutine dgemm_optimized

! Validation function
function validate(C1, C2, tolerance) result(is_valid)
    real(8), intent(in) :: C1(:,:), C2(:,:)
    real(8), intent(in) :: tolerance
    logical :: is_valid
    real(8) :: diff
    integer :: i, j
    
    is_valid = .true.
    !$OMP PARALLEL DO PRIVATE(i,j,diff) REDUCTION(.and.:is_valid)
    do j = 1, size(C1, 2)
        do i = 1, size(C1, 1)
            diff = abs(C1(i,j) - C2(i,j))
            if (diff > tolerance) is_valid = .false.
        end do
    end do
    !$OMP END PARALLEL DO
end function validate

end module dgemm_mod

program main
    use dgemm_mod
    implicit none
    integer, parameter :: num_tests = 3
    integer :: test_sizes(num_tests) = [512, 1024, 2048]
    integer :: block_sizes(num_tests) = [32, 64, 128]
    integer :: i, n, block_size
    real(8), allocatable :: A(:,:), B(:,:), C_naive(:,:), C_opt(:,:)
    real(8) :: time_start, time_end, gflops
    logical :: valid
    
    print '(a)', "Matrix Size | Block Size | Method   | Time (s) | GFLOPS   | Valid"
    print '(a)', repeat("-", 60)
    
    do i = 1, num_tests
        n = test_sizes(i)
        block_size = block_sizes(i)
        allocate(A(n,n), B(n,n), C_naive(n,n), C_opt(n,n))
        call random_number(A)
        call random_number(B)
        
        ! Benchmark optimized version
        call cpu_time(time_start)
        call dgemm_optimized(A, B, C_opt, block_size)
        call cpu_time(time_end)
        gflops = (2.0d0 * n**3) / (time_end - time_start) / 1e9
        valid = validate(matmul(A,B), C_opt, 1e-6)
        print '(i10, a, i8, a, a10, a, f9.3, a, f9.2, a, l5)', &
            n, " | ", block_size, " | ", "Optimized", " | ", &
            time_end - time_start, " | ", gflops, " | ", valid
        
        ! Benchmark naive version for smaller matrices
        if (n <= 1024) then
            call cpu_time(time_start)
            call dgemm_naive(A, B, C_naive)
            call cpu_time(time_end)
            gflops = (2.0d0 * n**3) / (time_end - time_start) / 1e9
            valid = validate(matmul(A,B), C_naive, 1e-6)
            print '(i10, a, i8, a, a10, a, f9.3, a, f9.2, a, l5)', &
                n, " | ", 0, " | ", "Naive", " | ", &
                time_end - time_start, " | ", gflops, " | ", valid
        end if
        
        deallocate(A, B, C_naive, C_opt)
    end do
    
    print '(a)', repeat("-", 60)
end program main
