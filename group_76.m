close all
interval = 10; % How long to plot

% Higher Order

numerator = 10; % F(s) Numerator
denominator = [1, 33, 409, 2127, 3440, 2750]; % Denominators of F1(s)
step_denominator = [1, 33, 409, 2127, 3440, 2750, 0]; % Denominators of F1(s)/s (step response)

sys1 = tf(numerator, denominator);

[r, p, k] = residue(numerator, step_denominator); % Finding the partial fractions for inverse laplace

%disp(table(r, p, 'VariableNames', {'Residues', 'Poles'}))

% Output:
    %       Residues                 Poles
    % _______________________    ____________
    % 
    %  -1.586e-05+0.00016389i       -10+5i   
    %  -1.586e-05-0.00016389i       -10-5i   
    % -0.00034619+0i                -11+0i   
    %  -0.0016292+0.0028724i         -1+1i   
    %  -0.0016292-0.0028724i         -1-1i   
    %   0.0036364+0i                  0+0i   

% Step response in time domain (inverse laplace transform):

t = linspace(0,interval,interval*50);
step_response = -0.00034619 .* exp(-11*t) + ...
    + 2 .* exp(-10*t) .* (-1.586e-05*cos(5*t) - (0.00016389)*sin(5*t)) ...
    + 2 .* exp(-t) .* (-0.0016292*cos(t) - (0.0028724)*sin(t)) ...
    + 0.0036364;


% Lower order approximation

low_numerator = 10; % F(s) Numerator
low_denominator = [1375, 2750, 2750]; % Denominators of F2(s)
step_low_denominator = [1375, 2750, 2750, 0]; % Denominators of F2(s)/s (step response)

sys2 = tf(low_numerator, low_denominator);

[r, p, k] = residue(numerator, step_low_denominator); % Finding the partial fractions for inverse laplace

disp(table(r,p, 'VariableNames', {'Residues', 'Poles'}))

% Output
%       Residues           Poles
% _____________________    _____
% 
% -0.0018182+0.0018182i    -1+1i
% -0.0018182-0.0018182i    -1-1i
%  0.0036364+0i             0+0i

% Time domain representation (inverse laplace transform)
low_step_response = 2 .* exp(-t) .* (-0.0018182*cos(t) - (0.0018182)*sin(t)) ...
    + 0.0036364;

% Plot the time step response


figure;
subplot(3,1,1)
step(sys1, t);
hold on;
plot(t, step_response, 'r--')
hold off;

subplot(3,1,2)
step(sys2, t);
hold on;
plot(t, low_step_response, 'r--')
hold off;

subplot(3,1,3)
step(sys1, t);
hold on;
step(sys2, t, 'r--');
legend('Nonlinear', 'Linear with offset', 'Location', 'southeast')
hold off;




