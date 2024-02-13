%% MARGINS TO FIND STABILITY
close all;
% System parameters
M = 0.052; % Mass
m = 0.136; % Additional mass
l = 0.23; % Length of the pendulum
g = 9.81; % Acceleration due to gravity
theta = 0; % current angle
A = 2*(m+3*M);
B = (1/3*m+M)*(2*l*(m+3*M));
C = (1/3*m+M)*(3*g*cos(theta)*(m+2*M));
num = [A];
den = [B 0 C];
system = 0.024 * tf(num, den);
% Analyze gain and phase margins
[gm, pm] = margin(system);
% Display margins
disp(['Gain Margin: ', num2str(gm), ' dB']);
disp(['Phase Margin: ', num2str(pm), ' degrees']);
% Stability analysis based on margins
if gm > 6 && pm > 30
   disp('System is stable.');
else
   disp('System is unstable.');
end
% Step response
t = 0:0.001:5;
[y, t] = step(system, t);
% Bode plot of the open-loop system
figure;
subplot(2, 1, 1);
bode(system);
title('Uncontrolled Bode Plot');
% Define PID controller
Kp = 5/.047; Ki = 4/.047; Kd = 0.5/.047; % due to changing PWM to voltage
H = pid(Kp, Ki, Kd);
% Create closed-loop system
G = feedback(series(system, H), 1);
% Bode plot of the closed-loop system
subplot(2, 1, 2);
bode(G);
title('Controlled Bode Plot');
% Analyze gain and phase margins
[gm, pm] = margin(G);
% Display margins
disp(['Gain Margin: ', num2str(gm), ' dB']);
disp(['Phase Margin: ', num2str(pm), ' degrees']);
% Stability analysis based on margins
if gm > 6 && pm > 30
   disp('System is stable.');
else
   disp('System is unstable.');
end