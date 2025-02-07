% Conjugate Gradient Solver for A*x = b

% Define matrix A and vector b
A = [4, -1, 0;
     -1, 4, -1;
      0, -1, 4];
b = [1; 2; 3];  % Ensure column vector

% Solver parameters
tol = 1e-6;
max_iter = 1000;

% Initialize variables
n = length(b);
x = zeros(n, 1);  % Initial guess
r = b - A * x;    % Initial residual
p = r;             % Initial search direction
rsold = r' * r;    % Initial residual squared norm

% Conjugate Gradient iterations
for iter = 1:max_iter
    Ap = A * p;               % Matrix-vector product
    alpha = rsold / (p' * Ap);  % Step size
    x = x + alpha * p;        % Update solution
    r = r - alpha * Ap;       % Update residual
    rsnew = r' * r;           % New residual squared norm
    
    % Check for convergence
    if sqrt(rsnew) < tol
        fprintf('Converged in %d iterations.\n', iter);
        break;
    end
    
    % Update search direction
    beta = rsnew / rsold;
    p = r + beta * p;
    rsold = rsnew;
end

% Handle non-convergence
if iter == max_iter && sqrt(rsnew) >= tol
    fprintf('Did not converge within %d iterations.\n', max_iter);
end

% Display results
disp('Solution x:');
disp(x);

% Validate by computing residual
residual = A * x - b;
residual_norm = norm(residual);
fprintf('Residual norm: %e\n', residual_norm);

% Compare with MATLAB's direct solver
x_exact = A \ b;
disp('Exact solution (A\b):');
disp(x_exact);

% Compute error norm
error_norm = norm(x - x_exact);
fprintf('Error norm: %e\n', error_norm);
