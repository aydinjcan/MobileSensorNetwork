function out = sensors(in)
%sensors    output sensor data

in = in(:);

%keyboard
M = in(1);
N = in(2);
u = in(3:(M-1)*(N-1)+2);
ns = in((M-1)*(N-1)+3);
s_pos = in((M-1)*(N-1)+4:(M-1)*(N-1)+2*ns+3);	%sensor position vector

%convert u to u_2d
u_2d = reshape(u,M-1,N-1);
%convert sensor_data to 2-column version
s_pos_2d = reshape(s_pos, length(s_pos)/2, 2);

hx = 1/M;
hy = 1/N;

u_sensed = [];
for i = 1:ns,
	i_pos = round(s_pos_2d(i,1)/hx);	%convert sensor x coordination to integer between [0,M]
	j_pos = round(s_pos_2d(i,2)/hy);	%convert sensor y coordination to integer between [0,N]
	if i_pos == 0,
		i_pos = 1;
	end
	if j_pos == 0,
		j_pos = 1;
	end
	if i_pos == M,
		i_pos = M-1;
	end
	if j_pos == N,
		j_pos = N-1;
    end
	u_sensed(i) = u_2d(i_pos,j_pos);
end

u_sensed = u_sensed(:);

%out = reshape([s_pos_2d,u_sensed],3*ns, 1);
out = u_sensed;

