close all
interval = 10; % How long to plot

% Higher Order

numerator = 10; % F(s) Numerator
denominator = [1, 33, 409, 2127, 3440, 2750]; % Denominators of F1(s)
step_denominator = [1, 33, 409, 2127, 3440, 2750, 0]; % Denominators of F1(s)/s (step response)

sys1 = tf(numerator, denominator);

[r, p, k] = residue(numerator, step_denominator); % Finding the partial fractions for inverse laplace

disp('5th order system poles & residues')
disp(table(r, p, 'VariableNames', {'Residues', 'Poles'}))

% Output:
    %       Residues                 Poles
    % _______________________    ____________
    % 
    %  -1.586e-05+0.00016389i       -10+5i   
    %  -1.586e-05-0.00016389i       -10-5i   
    %  -0.00034619+0i               -11+0i   
    %  -0.0016292+0.0028724i        -1+1i   
    %  -0.0016292-0.0028724i        -1-1i   
    %   0.0036364+0i                 0+0i   

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

disp('2nd order system poles & residues')
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

% Plot the step response of both systems
% 2nd order system overlaid on 5th order system
figure;
step(sys1, t);
hold on;
step(sys2, t, 'r--');
% Plot horizontal line at 0.5 * steady state to extract delay time
yline(0.0018181)
legend('Original Higher Order (5th) System', 'Lower Order (2nd) Approximation', 'Location', 'southeast')
hold off;

% Time domain properties - rise time, settling time, overshoot%

format long
% 5th order
info_5th = stepinfo(sys1)
% 2nd order
info_2nd = stepinfo(sys2)

% Delay time derived from measuring from plot

% s domain analysis
% Pole zero maps
pzopt = pzoptions;
pzopt.Grid = 'on';
pzopt.XLim = [-12 1];
pzopt.YLim = [-5.5 5.5];

figure;
subplot(1,2,1);
pz1 = pzplot(sys1, pzopt);
subplot(1,2,2);
pz2 = pzplot(sys2, pzopt);

% s domain properties
[wn1, zeta1, p1] = damp(sys1);
[wn2, zeta2, p2] = damp(sys2);

% Tabulate them:
format short
disp('5th Order System s-domain Properties')
sys1_properties = table(p1, wn1, zeta1, 'VariableNames', {'Pole', 'Natural Frequency', 'Damping Ratio'});
disp(sys1_properties);
disp("2nd Order Approximation s-domain Properties")
sys2_properties = table(p2, wn2, zeta2, 'VariableNames', {'Pole', 'Natural Frequency', 'Damping Ratio'});
disp(sys2_properties);

% Output
% 5th Order System s-domain Properties
%      Pole     Natural Frequency    Damping Ratio
%     ______    _________________    _____________
% 
%      -1+1i         1.4142             0.70711   
%      -1-1i         1.4142             0.70711   
%     -11+0i             11                   1   
%     -10+5i          11.18             0.89443   
%     -10-5i          11.18             0.89443   
% 
% 2nd Order Approximation s-domain Properties
%     Pole     Natural Frequency    Damping Ratio
%     _____    _________________    _____________
% 
%     -1+1i         1.4142             0.70711   
%     -1-1i         1.4142             0.70711   
