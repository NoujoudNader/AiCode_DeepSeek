

```bash
cg.f90:50:69:

   50 |   real(8) :: x_exact(n) = [13.0d0/28.0d0, 6.0d0/7.0d0, 27.0d0/28.0d0]
      |                                                                     1
Error: Unexpected data declaration statement at (1)
cg.f90:51:38:

   51 |   print *, "Exact solution: ", x_exact
      |                                      1
Error: Symbol 'x_exact' at (1) has no IMPLICIT type
```
