function out = ades(in)
% ades: actuator desired position. Output the desired position of each actuator.
%   The actuator is modeled as two double integrators: 
%               $\ddot x=f_x(t)$, 
%               $\ddot y=f_y(t)$.
%   $f_x(t)$ and $f_y(t)$ are defined in this file.
% added by haiyang for configuring how the robots go with CVT 2006/09/02

in = in(:);

NS = in(1);	% number of sensors
NA = in(2); % number of actuators

% actuator position matrix. [apos(i,1),apos(i,2)] is the current position 
% of the ith actuator 
apos = reshape(in(3:2*NA+2), NA, 2);	

% actuator velocity matrix. [avel(i,1),avel(i,2)] is the current velocity 
% of the ith actuator
avel = reshape(in(2*NA+3:4*NA+2), NA, 2);	

% current sensor infomation. 
% [sinfo(i,1),sinfo(i,2)] is the current position of the ith sensor
% [sinfo(i,3),sinfo(i,4)] is the current velocity of the ith sensor
% sinfo(i,5) is the sensed data of the ith sensor
sinfo = reshape(in(4*NA+3:4*NA+5*NS+2), NS, 5);

% current time
t = in(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code below this line should be written by the user to achieve the desired actuator movement. %
% The final output is a vector in the format of [fx_1,fx_2,...,fx_NA,fy_1,fy_2,...,fy_NA]'     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global p_out_des sum_s_des controlTime_des;

% every 0.2 update the control output
controlTime_des=controlTime_des+1;
if controlTime_des==100 %300 
    
    controlTime_des=0;        
    %arrays to record the points that is most close to i's actuator
    p=zeros(NA, 300);
    %array to indicate the number of points for each actuator
    p_index=zeros(NA,1);
    %array to storge the sensor information
    %find the Vi for each actuator
    p_out_des=zeros(NA,2);
    sum_s_des=zeros(NA,1);

    for i=1:NS
        min=( ( apos(1,1)-sinfo(i,1) )^2+( apos(1,2)-sinfo(i,2) )^2 );
        mini=1;
        for j=2:NA
            temp=( ( apos(j,1)-sinfo(i,1) )^2+( apos(j,2)-sinfo(i,2) )^2 );
            if temp < min
                min=temp;
                mini=j;
            end
        end
        p_index(mini)=p_index(mini)+1;
        p( mini,p_index(mini) )=i;
    end

    %figure out the mass central of the Vi
    des=zeros(NA,2);

    for i=1:NA
        sumx=0;
        sumy=0;
        sumd=0;
        for j=1:p_index(i)
            % added 20060903 to delete positions that sensor reading too small
%             if((sinfo(p(i,j),5) > 0.005)|(sinfo(p(i,j),5) < -0.005))
            if(sinfo(p(i,j),5) > 0.001) 
                sumx=sumx+sinfo(p(i,j),5)*sinfo( p(i,j),1);
                sumy=sumy+sinfo(p(i,j),5)*sinfo( p(i,j),2);
                sumd=sumd+sinfo(p(i,j),5);
        end
        end
        % added 2006/08/31 for exceptional condition dealing sumd = 0
        if(sumd == 0)
            des(i,1)=apos(i,1);
            des(i,2)=apos(i,2);
        else
            des(i,1)=sumx/sumd;
            des(i,2)=sumy/sumd;
        end
        sum_s_des(i)=sumd/p_index(i);
    end
    p_out_des = des;
end
out = reshape(p_out_des,1,2*NA);
