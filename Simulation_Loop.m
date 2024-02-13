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
for Kp = 25.0:-.1:0.1
   for Ki = 25.0:-.1:0.1
       for Kd = 25.0:-.1:0.1
           newKp = Kp/.047;
           newKi = Ki/.047;
           newKd = Kd/.047;
           H = pid(newKp, newKi, newKd);
           sys = feedback(series(system, H), 1);
           t = 0:0.01:10;
           y_simulated = step(sys, t);
           u = ones(1001);
           step_info = stepinfo(sys);
           settling_time = step_info.SettlingTime;
           if settling_time>10
               disp(['Kp: ', num2str(Kp), 'Ki: ', num2str(Ki), 'Kd: ',num2str(Kd),]);
           end 
       end
   end 
end
