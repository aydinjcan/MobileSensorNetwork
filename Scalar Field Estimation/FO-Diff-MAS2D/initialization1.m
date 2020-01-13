%diffusim_ini	 initilization of diffusion process control simulation 

%Last Modified: 08/26/04
%All Rights Reserved

%boundaries: x in [0,1], y in [0,1]

%the constant in the PDE
K = 0.01;
alpha=1.6; 
%discretization level
M = 30; %x axis is devided equally to M parts
N =30; %y axis is devided equally to N parts

%number of actuators, can be different from number of sensors
% NA = 81; %NO 5 is the moving obstacle.
NA = 4;

%number of sensors, can be different from number of actuators
NS = (M-1)*(N-1);

% number of disturbances
ND = 1;

%initial positions of actuators, number of rows should be equal to NA
% PA0	= [0.5,  0.5;
%        0.45, 0.5;
% 	   0.55, 0.5;
% 	   0.5,  0.45;
% 	   0.5,  0.55];

% PA0 = [0.05,0.05];

% PA0 = [0.1,0.9;
%     0.2,0.8;
%     0.2,0.7;
%     0.1,0.6];
        
 PA0=zeros(NA,2);
  k=1;
  interx=1/3;
  intery=1/3;
  for i=1:2;
      for j=1:2;
              PA0(k,1)=i*interx;
              PA0(k,2)=j*intery;
              k=k+1;
      end
  end
  
%             
%initial velocity of actuators, number of rows should be equal to NA
% VA0 = [0, 0;
%        0, 0;
% 	   0, 0;
% 	   0, 0;
%        -0.30, 0.0];
VA0=zeros(NA,2);
%initial positions of sensors, number of colomns should be equal to NS
% PS0	= [0.5,  0.5;
%        0.45, 0.5;
% 	   0.55, 0.5;
% 	   0.5,  0.45;
% 	   0.5,  0.55];

  PS0=zeros(NS,2);
  k=1;
  interx=1/M;
  intery=1/N;
  for i=1:M-1;
      for j=1:N-1
              PS0(k,1)=i*interx;
              PS0(k,2)=j*intery;
              k=k+1;
      end
  end
  

% initial velocity of sensors, number of columns should be equal to NS
% VS0 = [0, 0;
%        0, 0;
% 	   0, 0;
% 	   0, 0;
% 	   0, 0.01];
VS0 = zeros(NS,2);

%Dirichlet boundary conditions. Can be left blank if there is none.
%from [BDD(i,1),BDD(i,2)] to [BDD(i,3),BDD(i,4)], u=BDD(i,5)
%and so on. An example:
BDD = [0, 0, 0, 1, 0;	
	   0, 0, 1, 0, 0;
	   1, 1, 1, 0, 0;
	   1, 1, 0, 1, 0];


%Neumann boundary conditions. Can be left blank if there is none.
%from [BDN(i,1),BDN(i,2)] to [BDN(i,3),BDN(i,4], du/dn=BDN(i,5)+BDN(i,6)*u
%and so on. An example:
%BDN = [0,   0, 0.2, 0, 0, 0; 
%       0.8, 0, 1,   0, 0, 0;
%	    0,   0, 0,   1, 0, 0;
%	    1,   0, 1,   1, 0, 0;
%	    0,   1, 1,   1, 0, 0];
% BDN = [0,   0, 0,   1, 0, 0; 
% 	   0,   1, 1,   1, 0, 0;
% 	   1,   1, 1,   0, 0, 0;
% 	   1,   0, 0,   0, 0, 0];

%disturbances within boundary
%the initial position of the ith disturbance is at [PD0(i,1),PD0(i,2)]
 PD0 = [0.75, 0.35];
% PD0 = [0.8, 0.2];
% PD0 = [0.25, 0.25;
%     0.75,0.25;
%     0.25,0.75;
%     0.75,0.75];
%extra disturbance parameters, used in distout.m
DPARA = [1];
	   
%initial condition, only including states
for i = 1:(M-1),
	for j = 1:(N-1),
		%u_0((j-1)*(M-1)+i) = sin(pi/(M-2)*(i-1))*sin(pi/(N-2)*(j-1));
		u_0((j-1)*(M-1)+i) = 0;
	end
end

% with or without sensor noise, 0 or 1
SNOISE_EXIST = 0;

% mean of sensor noise, any number if SENSOR_NOISE_EXIST=0
MEAN_SNOISE = 0;

% variance of sensor noise, any number if SENSOR_NOISE_EXIST=0
VAR_SNOISE = 0.04;

%simulation time
SIMTIME =4;

%SIMTIME = 97 %for standard crop duster.

% After simulation finishes, generate plots along time every PLOTSTEP frames.
% Used to reduce the number of plots.
PLOTSTEP = 50;


%%  Qiu Added 03042014
FraAlpha=-0.6;n=4;
FraOrder = CalFracPra( FraAlpha,n);
%%

% added 20060831 for CVT + Consensus
global TotalSpray;
TotalSpray = zeros(1,NA);
global ControlInput;
global ActuatorVe;
global indexi;
indexi = 1

