%% SIMULATION
close all;
% System parameters
M = 0.052; % Mass
m = 0.136; % Additional mass
l = 0.23; % Length of the pendulum
g = 9.81; % Acceleration due to gravity
theta = 5/180*pi; % current angle
A = 2*(m+3*M);
B = (1/3*m+M)*(2*l*(m+3*M));
C = (1/3*m+M)*(3*g*cos(theta)*(m+2*M));
num = [A];
den = [B 0 C];
system = 0.024 * tf(num, den);
Kp = 5/.047; Ki = 4/.047; Kd = 0.5/.047; % due to changing PWM to voltage
H = pid(Kp, Ki, Kd);
sys = feedback(series(system, H), 1);
t = 0:0.01:10;
y_simulated = step(sys, t);
u = ones(1001);
figure;
plot(t, u, 'r--', 'LineWidth', 1.5);
hold on;
plot(t, y_simulated, 'b-', 'LineWidth', 1.5);
title('System Response to Step Input');
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('Step Input', 'System Response');
grid on;
step_info = stepinfo(sys)
settling_time = step_info.SettlingTime;
disp(['Settling Time (from stepinfo): ', num2str(settling_time), ' seconds']);