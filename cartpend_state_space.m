clear all, close all, clc

m = 1;
M = 5;
L = 2;
g = -10;
d = 1;

s = 1; % pendulum up (s=1)

A = [0 1 0 0;
    0 -d/M -m*g/M 0;
    0 0 0 1;
    0 -s*d/(M*L) -s*(m+M)*g/(M*L) 0];

B = [0; 1/M; 0; s*1/(M*L)];
eig(A)

rank(ctrb(A,B))  % is it controllable

% Pole placement
p = [-2; -2.1; -2.2; -2.3]; % good
%K = place(A,B,p)

% Place poles using LQR
Q = eye(size(A));
Q(1, 1) = 1;
Q(2, 2) = 1;
Q(3, 3) = 10;
Q(4, 4) = 100;
R = 0.01;
K = lqr(A,B,Q,R);

% Validate poles
poles = eigs(A-B*K)

% Simulate cartpend
tspan = 0:.001:10;
if(s==-1)
    y0 = [0; 0; 0; 0];
    [t,y] = ode45(@(t,y)cartpend(y,m,M,L,g,d,-K*(y-[4; 0; 0; 0])),tspan,y0);
elseif(s==1)
    y0 = [-3; 0; pi+.1; 0];
%     [t,y] = ode45(@(t,y)cartpend(y,m,M,L,g,d,-K*(y-[1; 0; pi; 0])),tspan,y0);
    [t,y] = ode45(@(t,y)cartpend(y,m,M,L,g,d,-K*(y-[1; 0; pi; 0])),tspan,y0);
else 
end

% Plot
plot(t, y)
title("Inverted Pendulum simulation")
xlabel("Time (s)")
legend(["position", "velocity", "angle", "angular velocity"])