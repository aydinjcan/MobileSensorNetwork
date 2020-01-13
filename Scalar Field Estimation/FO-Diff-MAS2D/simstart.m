%Here Sean had added some code in this function (Jianxiong Repeat 11/22/13)
% clear all
% close all
% 
% % global sums1;
% % global sums2;
% % global sums3;
% % global sums4;
% 
% 
% initialization
% 
% init_check
% 
% resp = '';
% while isempty(findstr('yn',resp))
%   resp = input('Are the initial conditions and boundary conditions what you want (y,n)? ','s');
%   resp = lower(resp);
% end
% 
% if resp == 'y', 
% 	pre_process
% 
% 	OPTIONS = simset('Solver', 'ode4', 'FixedStep', 0.002)
% 	%OPTIONS = simset('Solver', 'ode45');
% 	sim('diffu_ctrl_sim', SIMTIME, OPTIONS)
% 
% 	post_process
% end
 
clear all
close all
global ttt1;
ttt1 = clock;

NA=4;
global p_out  sum_s controlTime;
p_out=zeros(NA,2);
sum_s=zeros(NA,1);
controlTime=0;

global p_out_des  sum_s_des controlTime_des;
p_out_des=zeros(NA,2);
sum_s_des=zeros(NA,1);
controlTime_des=0;

% Added by Sean Rider for Standard Crop Dusting 
% global q dir;
% q = 1;
% dir = 1;
%%%%%


initialization1

init_check

resp = '';
% while isempty(findstr('yn',resp))
%   resp = input('Are the initial conditions and boundary conditions what you want (y,n)? ','s');
%   resp = lower(resp);
% end
% 
% if resp == 'y',
	pre_process_Riesz
    OPTIONS = simset('Solver', 'ode4', 'FixedStep', 0.004)
	sim('diffu_ctrl_sim', SIMTIME,OPTIONS)

   	post_process
    
    save CVT_Consensus
% end

display('My program takes about:');
display(etime(clock,ttt1));