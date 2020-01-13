%% Closed-loop dynamics of a unicycle agents under the 
%  proposed control strategy.
%
% (C) Kaveh Fathian, 2018.  Email: kaveh.fathian@gmail.com
%
function dstate = UnicycleSatSys_Dynam_ColAvoid_Ver2_1(t,state,par)

A           = par.A;                  % Control gain matrix
n           = par.n;                  % Number of agents
omegaSat    = par.omegaSat;           % Heading angle saturation 
vSat        = par.vSat;               % Speed saturation
Dd          = par.Dd;                 % Desired distances
coef        = par.coef;               % Coefficients for linear and angular velocity dynamics

dcoll       = par.dcoll;              % Collision avaoidance distance 
rcoll       = par.rcoll;              % Collision avaoidance circle radius


%% Preallocate variables

q       = state(1:2*n);         % Position vector
theta   = state(2*n+1: 3*n);    % Heading 
vel     = state(3*n+1: 4*n);    % Linear velocity 
omega   = state(4*n+1: 5*n);    % Angular velocity 

H       = zeros(2*n, n);        % Heading matrix
Hp      = zeros(2*n, n);        % Perpendicular heading matrix
R       = [0 -1; 1 0];          % 90 degree roation matrix

% Heading vectors
h = [cos(theta).'; sin(theta).'];
h = h(:);

% Perpendicular vectors
for i = 1 : n    
    H(2*i-1:2*i,i) = h(2*i-1:2*i);
    Hp(2*i-1:2*i,i) = R * h(2*i-1:2*i);
end


%% Initial control direction

 % Inter-agent distance matrix
 Dc = zeros(n,n);
 for i = 1 : n
     for j = i+1 : n
         Dc(i,j) = norm(q(2*i-1:2*i)-q(2*j-1:2*j),2);
     end
 end
 Dc = Dc + Dc';

 % Control to fix the scale
 g = 3; % Gain
 F = g * atan( A.* A_C2R(Dc-Dd) );
 F = F + diag(-sum(F,2));

 % Desired direction of motion
gain = 1;
% dq0 = gain * ( A * q  + F * q );  % Fixed-scale
dq0 = gain * A * q ;   % Free-scale

% Positions in matrix form
qm = zeros(2,n);
for i = 1 : n
    qm(:,i) = [q(2*i-1); q(2*i)];
end

% Control direction in matrix form
ctrl = zeros(2,n);
for i = 1 : n
    ctrl(:,i) = [dq0(2*i-1); dq0(2*i)];
end


%% Collision avoidance

u = ColAvoid_Ver2_0(ctrl, qm, par);


%% Unicycle Control

% Control for unicycle agents
s   = H.' * u;
r   = Hp.' * u;

% Speed limiter
vMin = ones(size(s)) * vSat(1);
vMax = ones(size(s)) * vSat(2);
s = max(s, vMin);
s = min(s, vMax);

% Heading angle rate of change limiter
omegaMin = ones(size(r)) * omegaSat(1);
omegaMax = ones(size(r)) * omegaSat(2);
r = max(r, omegaMin);
r = min(r, omegaMax);

% Coefficients for linear and angular velocity dynamics
a = coef.a;
b = coef.b;
c = coef.c;
d = coef.d;

% Derivative of state
dq      = H * vel; 
dtheta  = omega;
dvel    = - diag(a) * vel + diag(b) * s;
domega  = - diag(c) * omega + diag(d) * r;

dstate  = [dq; dtheta; dvel; domega]; 


end





































































