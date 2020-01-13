function out = actrl(in)
% actrl: actuator position control. Output the acceleration of each actuator.
%   The actuator is modeled as two double integrators: 
%               $\ddot x=f_x(t)$, 
%               $\ddot y=f_y(t)$.
%   $f_x(t)$ and $f_y(t)$ are defined in this file.

%  keyboard
in = in(:);

NS = in(1);	% number of sensors
NA = in(2); % number of actuators

% added 20060831 for CVT + consensus
% --case(1)Neighbour talk 1<->2,1<->3,4<->2,3<->4,
% Lmatrix1 = [-3 1 1 0; 1 -3 0 1; 1 0 -3 1;0 1 1 -3];
% Lmatrix2 = [-2 1 1 0; 1 -2 0 1; 1 0 -2 1;0 1 1 -2];
% --Case(2)Broadcast 3->1,3->2,3->4
% Lmatrix1 = [-2 0 1 0;0 -2 1 0;0 0 -1 0;0 0 1 -2];
% Lmatrix1 = [-2 0 -1 0;0 -2 -1 0;0 0 -3 0;0 0 -1 -2];
% Lmatrix1 = [-1 0 -2 0;0 -1 -2 0;0 0 -3 0;0 0 -2 -1];
% --Case(3) 3->1->2,3->4->2
% Lmatrix1 = [-2 0 1 0;1 -3 0 1;0 0 -1 0;0 0 1 -1];
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

%% approximation of gradient
%ugrad = 0.5*[sinfo(3,5)-sinfo(2,5),sinfo(5,5)-sinfo(4,5)];

%% controller gain
%k1 = 180;
%k2 = 30;

%% single controller output
%sout = k1*ugrad-k2*[sinfo(1,3),sinfo(1,4)];

%out = reshape([sout;sout;sout;sout;sout], 10,1);

%out = zeros(NA,1);


global p_out sum_s controlTime;

%my code
%use global sensor information

%control position when 1/10th


 if t >2


controlTime=controlTime+1;
% sout5=[0;0];
if controlTime==100 %300 
    controlTime=0;        
    %arrays to record the points that is most close to i's actuator
    p=zeros(NA, 300);
    %array to indicate the number of points for each actuator
    p_index=zeros(NA,1);

    %array to storge the sensor information

    %find the Vi for each actuator
    p_out=zeros(NA,2);
    sum_s=zeros(NA,1);
    %design acceleration for each actuator
     k1=6;%3
     k2=1;
%      k1 = 0;
%      k2 = 0;

    % Voronoi Diagram computing (Nearest actuator strategy)
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
        if(min < 0.04)  % added this condition 20060923 for increasing PrayK
            p_index(mini)=p_index(mini)+1;
            p( mini,p_index(mini) )=i;
        end
    end

    if t==0.1 
        p;
        plot(p_index);
        keyboard
    end
    %figure out the mass central of the Vi
    des=zeros(NA,2);

    for i=1:NA

        sumx=0;
        sumy=0;
        sumd=0;
        for j=1:p_index(i)
            % added 20060903 to delete positions that sensor reading too small
    %        if((sinfo(p(i,j),5) > 0.005)|(sinfo(p(i,j),5) < -0.005))
%              if(sinfo(p(i,j),5) > 0)   
                sumx=sumx+sinfo(p(i,j),5)*sinfo( p(i,j),1);
                sumy=sumy+sinfo(p(i,j),5)*sinfo( p(i,j),2);
                sumd=sumd+sinfo(p(i,j),5);
%             end
        end

        % added 2006/08/31 for exceptional condition dealing sumd = 0
        if(sumd == 0)
            des(i,1)=apos(i,1);
            des(i,2)=apos(i,2);
            sum_s(i)=0;
        else
            des(i,1)=sumx/sumd;
            des(i,2)=sumy/sumd;
            sum_s(i)=sumd/p_index(i);

            % if t==0.1
            if t==0.2
                    i
            end
           p_out(i,:)=k1*(des(i,:)-apos(i,:)) - k2*avel(i,:);
% add 20060904 for 1st order control and consensus
           
%             p_out(i,:)=k1*(des(i,:)-apos(i,:));
            
%             kh = health(i,t,p_out(i,:)); %health gain modifier for actuator health
%             
%             p_out(i,:) = kh.*p_out(i,:); %why comment this
%            
        end
    end
% added 20060904 for second order consensus control input
% p_out = Lmatrix1*(apos-des)+Lmatrix2*avel;
%     if(t<2)
%         Lmatrix3 = [-2 0 -1 0;0 -2 -1 0;0 0 -3 0;0 0 -1 -2];
%         p_out = Lmatrix3*(apos-des);
%     elseif ((t > 2) && (sum(sum_s/sum_s(3)) < 2))
% %     if ( sum(sum_s/sum_s(3)) < 2)
%         Lmatrix1 = [-1 0 1 0;0 -1 1 0;0 0 -1 0;0 0 1 -1];
%         Lmatrix2 = [0 0 0 0;0 0 0 0;0 0 -1 0;0 0 0 0 ];
%         p_out = Lmatrix1*apos-Lmatrix2*des;
%         t
%     else
%         Lmatrix0 = (-1)*k1*eye(NA,NA);
%         p_out = Lmatrix0*(apos-des);
%     end
end
% temp=robot2obstacle_f(apos(1,:), avel(1,:), apos(5,:), avel(5,:) );
% tsout1=sout1+temp;
% 
% temp=robot2obstacle_f(apos(2,:), avel(2,:), apos(5,:), avel(5,:) );
% tsout2=sout2+temp;
% 
% temp=robot2obstacle_f(apos(3,:), avel(3,:), apos(5,:), avel(5,:) );
% tsout3=sout3+temp;
% 
% temp=robot2obstacle_f(apos(4,:), avel(4,:), apos(5,:), avel(5,:) );
% tsout4=sout4+temp;

% p_out = p_out + Lmatrix*apos;
% The following equation can be used to test how robots go without sensor
% inputs 2006 0831 by haiyang Chao
% p_out = -avel + Lmatrix*apos;

if(t > 0.2)
   fgorki = 1; 
end
 end
out = reshape(p_out, 2*NA,1);
% global indexi;
% global ControlInput;
% global ActuatorVe;
% ControlInput(:,indexi) = out;
% ActuatorVe(:,indexi) = reshape(avel, 2*NA,1);
% indexi = indexi+1;

% out = reshape([sout1;sout2;sout3;sout4;sout5], 10,1);
% else 
%     
%  out=zeros(8,1);
% end
%  out=zeros(10,1);
% out=[out 0 0];
% t
% p1
% p2
% p3
% p4

