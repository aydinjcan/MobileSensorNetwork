% This script simulates formation control of a group of unicycles.
% This line here is a test to ensure that github is working
%
% -------> IMPORTANT:  CVX must be installed before running this script! 
%
% -------> Download CVX from:  http://cvxr.com/cvx/
%
% -------> Scale of the formation is NOT controlled in this demo, but can
%          be controlled by uncommenting the corresponding controller in 
%          "UnicycleSatSys_Dynam_ColAvoid_Ver2_1.m" 
%
% -------> Increase number of time samples in the simulation interval for a
%          smoother simulation video
%
% -------> This script is tested in Matlab 2017b, Windows 7, 64-bit
%
%
% (C) Kaveh Fathian, 2018.  Email: kaveh.fathian@gmail.com
%
% This program is a free software: you can redistribute it and/or modify it
% under the terms of the GNU lesser General Public License, either version 
% 3, or any later version. This program is distributed in the hope that it 
% will be useful, but WITHOUT ANY WARRANTY. 
%

addpath('Helpers');


%% Simulation parameters

% Desired 2D formation coordinates (change to your desired formation coordinates)
qs = [0     0     0    -1    -1    -1    -2    -2    -2
      0    -1    -2     0    -1    -2     0    -1    -2]*15;
  
% Random initial positions (can replace with any other value)
q0 = [18.2114   14.9169    7.6661   11.5099    5.5014    9.0328   16.0890    0.5998    1.7415;
      16.0112   16.2623   12.3456   10.6010    4.9726    4.5543   19.7221   10.7133   16.0418]*2.5;
% Initial headings (in radians)
theta0 = [4.6536    4.6727    0.6655    4.2824    2.9108    1.3331    0.6190     5.1747    1.0996].';
  
n  = size(qs,2);       % Number of agents

% Graph adjacency matrix
adj = [  0     1     0     1     0     0     0     0     0
         1     0     1     0     1     0     0     0     0
         0     1     0     0     0     1     0     0     0
         1     0     0     0     1     0     1     0     0
         0     1     0     1     0     1     0     1     0
         0     0     1     0     1     0     0     0     1
         0     0     0     1     0     0     0     1     0
         0     0     0     0     1     0     1     0     1
         0     0     0     0     0     1     0     1     0];

% Random coefficients for linear and angular velocity dynamics (can replace with any other positive value)
coef.a = [6.2085    7.0196    5.4823    5.6599    9.7103    9.7807    7.8760    5.2989    6.1739];
coef.b = [6.7658    9.1060    5.0770    5.2151    5.8450    8.2456    8.6586    8.2387    7.2546];
coef.c = [7.7350    6.4816    8.7235    5.9448    8.4339    5.9176    6.8424    8.1281    8.9011];
coef.d = [5.4056    9.6469    8.8786    7.4340    7.1793    7.2339    6.5317    7.5425    7.5539];


%% Parameters

T               = [0, 100];      % Simulation time interval 
numTimeSamples  = 30;           % Number of simulation time samples (increase for a smoother video)
vidFrameRate    = 10;           % Frame rate of simulation video
vidQuality      = 50;           % Video quality (values between 1 to 100)
traceLength     = 10;           % Trajectory trace length in the video

vSat        = [-3, 3];          % Allowed speed range
omegaSat    = [-pi/4, pi/4];    % Allowed heading angle rate of change


%% Computing formation control gains

% Find stabilizing control gains (Needs CVX)
A = FindGains(qs(:), adj);

% % If optimization failed, perturbe 'qs' slightly:
% A = FindGains(qs(:)+0.0001*rand(2*n,1), adj);


%% Desired distance matrix

% Element (i,j) in matrix Dd describes the distance between agents i and j 
% in the formation. The diagonals are zero by definition.
Dd = zeros(n,n); % inter-agent distances in desired formation
for i = 1 : n
    for j = i+1 : n
        Dd(i,j) = norm(qs(:,i)-qs(:,j), 2);
    end
end
Dd = Dd + Dd';


%% Simulate the unicycle model

% Simulation time                 
Tvec = linspace(T(1), T(2), numTimeSamples);

% Initial state
vel0    = zeros(size(theta0));
omega0  = zeros(size(theta0));
state0  = [q0(:); theta0; vel0; omega0];    

% Parameters passed down to the ODE solver
par.n           = n;                   % Number of agents
par.A           = A;                   % Control gain matrix
par.vSat        = vSat;                % Saturation range of linear velocity
par.omegaSat    = omegaSat;            % Saturation range of angular velocity
par.dcoll       = 7.5;                 % Collision avaoidance distance
par.rcoll       = 4;                   % Collision avaoidance circle radius
par.Dd          = Dd;                  % Desired distances
par.coef        = coef;                % Coefficients for linear and angular velocity dynamics

% Simulate the dynamics
opt = odeset('AbsTol', 1.0e-04, 'RelTol', 1.0e-04);
[t,stateMat] = ode45(@UnicycleSatSys_Dynam_ColAvoid_Ver2_1, Tvec, state0, opt, par);


%% Make movie and plot the results

% Plot parameters
plotParam.adj       = adj;
plotParam.N         = n;
plotParam.stateMat  = stateMat;
plotParam.trace     = traceLength;      % Trace length 
plotParam.vidFrameRate = vidFrameRate;  % Video frame rate
plotParam.vidQuality   = vidQuality;    % Video quality

% Make movie 
fileName = 'UnicycleSim';
MovieUnicycleVer2_1(fileName, plotParam)

