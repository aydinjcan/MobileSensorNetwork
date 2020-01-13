function out = controller(in)
% controller: control algorithm of each actuator for diffusion process control
% keyboard
in = in(:);
% number of sensors
NS = in(1);

% current sensor information. 
% [sinfo(i,1),sinfo(i,2)] is the current position of the ith sensor
% [sinfo(i,3),sinfo(i,4)] is the current velocity of the ith sensor
% sinfo(i,5) is the sensed data of the ith sensor
sinfo = reshape(in(2:5*NS+1), NS, 5);

% number of actuators
NA = in(5*NS+2);

% actuator information. 
% [ainfo(i,1),ainfo(i,2)] is the current position of the ith actuator.
% [ainfo(i,3),ainfo(i,4)] is the current velocity of the ith actuator.
ainfo = reshape(in(5*NS+3:5*NS+4*NA+2), NA, 4);

% How much neutralizing material have been sprayed?
NeutraSprayed = reshape(in(5*NS+4*NA+3:5*NS+5*NA+2), NA, 1); 

% current time
t = in(end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% code below this line is to be written by the user to achieve the desired diffusion control %
% The final Output should be a vector in the format of [output_1,output_2,...,output_NA]     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sum_s;

 k_gain = 80;%80
% without control
% %out = -k_gain*sinfo(:,end);
out = zeros(NA,1);
%the controller is to use p controller for global sensor information
%later can be respect to local sensor information, see which better
% % t

for i=1:NA
%     out(i)=-k_gain*sum_s(i);  
    if (8+NeutraSprayed(i)) > 0
        out(i) = (8 + NeutraSprayed(i))*(-k_gain)*sum_s(i);
    else
        out(i) = 0;
    end
   %add saturation for spraying speed.
    if (out(i) < -2)
        out(i) = -2;
    end
% out(i) = -2;
 end
t;
  