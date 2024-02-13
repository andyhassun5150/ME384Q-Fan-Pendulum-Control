%% ROOT LOCUS
close('all')
% Plant transfer function
% System parameters
M = .052; % Mass
m = .136; % Additional mass
l = .23; % Length of the pendulum
g = 9.81; % Acceleration due to gravity
theta = 0; % current angle
% Given characteristic equation coefficients
A = 2*(m+3*M);
B = (1/3*m+M)*(2*l*(m+3*M));
C = (1/3*m+M)*(3*g*cos(theta)*(m+2*M));
% Characteristic equation
num = [A];
den = [B 0 C];
% Create a transfer function
G = .024* tf(num, den); % .024 is due to linearizing the force from the pwm of the motor
figure;
rlocus(G);
grid on;
% Proportional-Integral-Derivative (PID) controller
Kp = 5/.047; Ki = 4/.047; Kd = 0.5/.047; % due to changing PWM to voltage
figure;
% Closed-loop transfer function with PID control
H = pid(Kp, Ki, Kd);
T = feedback(G * H, 1);
% Plot the root locus
rlocus(T);
grid on;
title('Root Locus with PID Control');