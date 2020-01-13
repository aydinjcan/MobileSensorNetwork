function out = disturout(in)
%disturout	disturbance output

%keyboard
ND = in(1);
% the ith row shows the ith disturbance with position [dinfo(i,1),dinfo(i,2)] and force dinfo(i,3) 
dinfo = reshape(in(2:end-2),ND,3);
M = in(end-1);
N = in(end);

hx = 1/M;
hy = 1/N;

out = zeros((M-1)*(N-1),1);
for i = 1:ND,
	i_pos = round(dinfo(i,1)/hx);	%convert sensor x coordination to integer between [0,M]
	j_pos = round(dinfo(i,2)/hy);	%convert sensor y coordination to integer between [0,N]
	if i_pos==0 || i_pos==M || j_pos==0 || j_pos==N,
		%if disturbances are on the boundary, no output
		continue;
	end
	out((j_pos-1)*(M-1)+i_pos) = dinfo(i,3);
end



