function out = sctrl(in)
% sctrl: sensor position control. Output the acceleration of each sensor.
%   The sensor is modeled as two double integrators: 
%               $\ddot x=f_x(t)$, 
%               $\ddot y=f_y(t)$.
%   $f_x(t)$ and $f_y(t)$ are defined in this file.

in = in(:);

NS = in(1);	% number of sensors
NA = in(2); % number of actuators

% sensor position matrix. [spos(i,1),spos(i,2)] is the current position of the ith sensor 
spos = reshape(in(3:2*NS+2), NS, 2);	

% sensor velocity matrix. [svel(i,1),svel(i,2)] is the current velocity of the ith sensor
svel = reshape(in(2*NS+3:4*NS+2), NS, 2);	

% current sensor data. sdata(i) is the current sensed data of the ithe sensor
sdata = in(4*NS+3:5*NS+2);

% actuator information. 
% [ainfo(i,1),ainfo(i,2)] is the current position of the ith actuator.
% [ainfo(i,3),ainfo(i,4)] is the current velocity of the ith actuator.
ainfo = reshape(in(5*NS+3:5*NS+4*NA+2), NA, 4);

% current time
t = in(end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code below this line should be written by the user to achieve the desired sensor movement.  %
% The final output is a vector in the format of [fx_1,fx_2,...,fx_NA,fy_1,fy_2,...,fy_NA]'    % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % approximation of gradient
% ugrad = 0.5*[sdata(3)-sdata(2),sdata(5)-sdata(4)];
% 
% % controller gain
% k1 = 180;
% k2 = 30;
% 
% % single controller output
% sout = k1*ugrad-k2*svel(1,:);
% 
% % out = reshape([sout;sout;sout;sout;sout], 10,1);
out = zeros(2*NS, 1);

%no need to change



