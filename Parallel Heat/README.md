## Compilation errors

### Fortran

```bash
gfortran heat.f90 -p heat-f
heat.f90:31:21:

   31 |         u(i) = sin(pi * x(i))
      |                     1
Error: Symbol ‘pi’ at (1) has no IMPLICIT type; did you mean ‘i’?
```


