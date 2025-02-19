program stream_triad
    use, intrinsic :: iso_fortran_env, only: real64, int64
    implicit none
    integer(int64), parameter :: N = 2**27  ! 134,217,728 elements (~1GB per array)
    real(real64), parameter :: scalar = 3.0_real64
    real(real64), allocatable :: A(:), B(:), C(:)
    integer(int64) :: chunk_size, i
    real(real64) :: start_time, end_time
    integer :: num_images, me, ierr
    
    ! Initialize parallel environment
    num_images = num_images()
    me = this_image()
    
    ! Calculate chunk size with load balancing
    chunk_size = N / num_images
    if (me <= mod(N, num_images)) chunk_size = chunk_size + 1
    
    ! Allocate aligned memory (assuming compiler supports alignment)
    allocate(A(chunk_size), B(chunk_size), C(chunk_size), stat=ierr)
    if (ierr /= 0) error stop 'Memory allocation failed'
    
    ! Initialize arrays
    B = 1.0_real64
    C = 2.0_real64
    
    ! Synchronize all images and time the triad operation
    sync all
    if (me == 1) call cpu_time(start_time)
    
    ! Main triad operation with explicit SIMD vectorization
    do concurrent (i = 1:chunk_size)
        A(i) = B(i) + scalar * C(i)
    end do
    
    ! Calculate performance metrics
    sync all
    if (me == 1) then
        call cpu_time(end_time)
        print '(a)', 'STREAM Triad Benchmark Results:'
        print '(a,i0)', ' Number of images: ', num_images
        print '(a,i0,a)', ' Array size: ', N, ' elements per array'
        print '(a,f6.3,a)', ' Total time: ', end_time - start_time, ' seconds'
        print '(a,f6.1,a)', ' Bandwidth: ', &
            (3.0_real64 * 8.0_real64 * N) / (end_time - start_time) / 1e9, ' GB/s'
        print '(a,3f8.1)', ' Sample values: ', A(1:3)
    end if
    
    deallocate(A, B, C)
end program stream_triad
