program compute_area
    implicit none
    real(8), parameter :: pi = 4.0_8 * atan(1.0_8) ! Define π
    real(8) :: a, b, area, exact_area, difference
    integer :: n, i
    real(8) :: h, x, sum

    ! Define the limits of integration
    a = -pi           ! -π
    b = (2.0_8 / 3.0_8) * pi  ! 2/3π

    ! Number of intervals for the trapezoidal rule
    n = 1000

    ! Step size
    h = (b - a) / n

    ! Initialize the sum for the trapezoidal rule
    sum = 0.5_8 * (sin(a) + sin(b))

    ! Compute the sum for the trapezoidal rule
    do i = 1, n-1
        x = a + i * h
        sum = sum + sin(x)
    end do

    ! Compute the area using the trapezoidal rule
    area = sum * h

    ! Print the computed area
    print *, 'The area between -π and 2/3π for sin(x) is: ', area

    ! Validation: Compute the exact area using the antiderivative of sin(x)
    ! The antiderivative of sin(x) is -cos(x)
    exact_area = (-cos(b)) - (-cos(a))

    ! Print the exact area
    print *, 'The exact area computed using the antiderivative is: ', exact_area

    ! Compare the numerical and exact results
    difference = abs(area - exact_area)
    print *, 'Difference between numerical and exact area: ', difference

end program compute_area
