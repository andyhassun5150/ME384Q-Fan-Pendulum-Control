
close('all')
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
for Kd = 25.0:-1.0:0.0
   for Ki = 25.0:-1.0:0.0
       for Kp = 25.0:-1.0:0.0
           H = pid(Kp, Ki, Kd);
           T = feedback(G * H, 1);
           poles = pole(T);
           if all(real(poles) < 0)
               % disp('The system is stable.');
else
               disp('the system is unstable');
               disp(['Kp: ', num2str(Kp), '
num2str(Kd),]);
           end 
       end
   end 
end