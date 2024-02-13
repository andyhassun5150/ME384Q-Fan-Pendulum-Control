clear all

syms s m l g thetad M Kp Ki Kd Ti Td Co P Fg

% A = [0 -(0.5*m+M)*g*cos(thetad)/(((1/3)*m+M)*l);
%     1 0];

A = [0 -Fg*cos(thetad)/P;
    1 0];

sI_A = s*eye(2) - A;

% B = [1/(((1/3)*m+M)*l) -(0.5*m+M)*g*(sin(thetad)-cos(thetad)*thetad)/(((1/3)*m+M)*l);
%     0 0];

B = [0.024/P;
    0];

C = [0 1];

D = [0 0];

inv_A = inv(sI_A);

G_p = C*inv_A*B+D

% G_c = Kp + Ki/s + Kd*s;
G_c = Kp*( 1+ 1/(Ti*s) + Td*s);

G_cl = G_c*G_p(1)/(1+G_c*G_p(1));

simplify(G_cl)

G_cG_p = G_c*G_p(1);
simplify(G_cG_p);

% num = [6];
% den = [2*m*l 0 3*m*g*sin(thetad)+3*m*g*cos(thetad)];
% 
% sys_ol = tf(num,den);
% sys_cl = feedback(sys_ol,1);
