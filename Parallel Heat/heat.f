program heat_equation
    use omp_lib
    implicit none

    ! Parameters
    integer, parameter :: n = 100          ! Spatial points
    real(8), parameter :: alpha = 0.1d0    ! Thermal diffusivity
    real(8), parameter :: L = 1.0d0        ! Domain length
    real(8), parameter :: T_total = 0.1d0  ! Total simulation time
    real(8) :: h, dt                       ! Spatial and temporal steps
    integer :: nt, i, t                    ! Counters
    
    ! Arrays
    real(8), dimension(:), allocatable :: x, u, unew, analytical
    
    ! Error calculation
    real(8) :: l2_error, exp_factor

    ! Set derived parameters
    h = L / (n - 1)
    dt = T_total / 1000.0d0
    nt = int(T_total / dt)

    ! Allocate arrays
    allocate(x(n), u(n), unew(n), analytical(n))

    ! Initialize spatial grid and solution
    !$OMP PARALLEL DO PRIVATE(i)
    do i = 1, n
        x(i) = (i-1)*h
        u(i) = sin(pi * x(i))
    end do
    !$OMP END PARALLEL DO

    ! Main time-stepping loop
    do t = 1, nt
        ! Parallel computation of interior points
        !$OMP PARALLEL DO PRIVATE(i)
        do i = 2, n-1
            unew(i) = u(i) + alpha * dt * (u(i+1) - 2.0d0*u(i) + u(i-1)) / h**2
        end do
        !$OMP END PARALLEL DO

        ! Apply boundary conditions
        unew(1) = 0.0d0
        unew(n) = 0.0d0

        ! Update solution array
        u = unew
    end do

    ! Compute analytical solution
    exp_factor = exp(-alpha * pi**2 * T_total)
    !$OMP PARALLEL DO PRIVATE(i)
    do i = 1, n
        analytical(i) = exp_factor * sin(pi * x(i))
    end do
    !$OMP END PARALLEL DO

    ! Calculate L2 error
    l2_error = sqrt(h * sum((u - analytical)**2))
    print *, 'L2 Error:', l2_error

    ! Write results to file
    open(unit=10, file='results.csv', status='replace')
    write(10, '(A)') 'x,Numerical,Analytical'
    do i = 1, n
        write(10, '(F10.6,A,F12.8,A,F12.8)') x(i), ',', u(i), ',', analytical(i)
    end do
    close(10)

    ! Cleanup
    deallocate(x, u, unew, analytical)

end program heat_equation
