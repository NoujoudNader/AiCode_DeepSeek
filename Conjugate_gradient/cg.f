program conjugate_gradient
  implicit none
  integer, parameter :: n = 3
  real(8) :: b(n) = [1.0d0, 2.0d0, 3.0d0]
  real(8) :: x(n), r(n), p(n), Ap(n)
  real(8) :: rsold, rsnew, alpha, beta, tol
  integer :: iter, max_iter = 1000

  ! Initialize solution vector
  x = 0.0d0

  ! Initial residual (r = b - A*x, x=0)
  r = b
  p = r
  rsold = dot_product(r, r)

  tol = 1.0d-6

  ! Conjugate Gradient iterations
  do iter = 1, max_iter
    call matrix_vector_mult(p, Ap)
    alpha = rsold / dot_product(p, Ap)
    
    ! Update solution and residual
    x = x + alpha * p
    r = r - alpha * Ap
    
    rsnew = dot_product(r, r)
    if (sqrt(rsnew) < tol) then
      print *, "Converged in ", iter, " iterations"
      exit
    end if
    
    beta = rsnew / rsold
    p = r + beta * p
    rsold = rsnew
  end do

  if (iter > max_iter) print *, "Did not converge"

  ! Output results
  print *, "CG Solution: ", x

  ! Validate solution
  call matrix_vector_mult(x, Ap)
  r = Ap - b
  print *, "Residual norm: ", sqrt(dot_product(r, r))

  ! Exact solution (precomputed)
  real(8) :: x_exact(n) = [13.0d0/28.0d0, 6.0d0/7.0d0, 27.0d0/28.0d0]
  print *, "Exact solution: ", x_exact
  print *, "Error norm: ", sqrt(dot_product(x - x_exact, x - x_exact))

contains
  ! Tridiagonal matrix-vector multiplication (optimized for this specific matrix)
  subroutine matrix_vector_mult(vec_in, vec_out)
    real(8), intent(in)  :: vec_in(n)
    real(8), intent(out) :: vec_out(n)
    
    vec_out(1) = 4.0d0 * vec_in(1) - vec_in(2)
    vec_out(2) = -vec_in(1) + 4.0d0 * vec_in(2) - vec_in(3)
    vec_out(3) = -vec_in(2) + 4.0d0 * vec_in(3)
  end subroutine matrix_vector_mult
end program conjugate_gradient
