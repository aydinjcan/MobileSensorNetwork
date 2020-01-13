function out = distout(in)
%out = distout(in)   return positions and disturbing forces at current time 

ND = in(1);	%number of disturbances
PD0 = reshape(in(2:2*ND+1), ND, 2);	% initial disturbance position matrix
t = in(2*ND+2);% current time
DEXTRA = in(2*ND+3:end); % extra information of disturbance. The first element is length of DPARA
if DEXTRA(1) > 0,
	DPARA = DEXTRA(2:end); % extra disturbance pamameters
else
	DPARA = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code below this line should be written by the user to specify %
% the disturbance positions and disturbing forces at time t.    % 
% The output is a vector with length 3*ND.                      % 
% out=[x_1,x_2,...,x_ND,y_1,y_2,...,y_ND,fd_1,fd_2,...,fd_ND]'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% period of the 2nd disturbance
% T = 10;	 
% omega = 2*pi/T;
% x0 = PD0(1,1);
% y0=PD0(1,2);
% phi0 = asin(2*(x0-0.5));
% x = 0.3*sin(omega*t+phi0) + 0.5;
% out = [x, PD0(1,2), 5]';

%change by wzm
% out = [PD0(:); exp(-DPARA(1)*t)];
% changed 20060903 for different diffusion source: consistent step respulse
out = [PD0(:); 20*exp(-DPARA(1)*t)];
% out = [PD0(:); 20];

