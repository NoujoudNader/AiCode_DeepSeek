% Define the function sin(x)
integrand = @(x) sin(x);

% Define the limits of integration
a = -pi;          % -π
b = (2/3) * pi;   % 2/3π

% Compute the area using numerical integration
area = integral(integrand, a, b);

% Display the computed area
fprintf('The area between -π and 2/3π for sin(x) is: %.6f\n', area);

% Validation: Compute the exact area using the antiderivative of sin(x)
% The antiderivative of sin(x) is -cos(x)
exact_area = (-cos(b)) - (-cos(a));

% Display the exact area
fprintf('The exact area computed using the antiderivative is: %.6f\n', exact_area);

% Compare the numerical and exact results
difference = abs(area - exact_area);
fprintf('Difference between numerical and exact area: %.6f\n', difference);
