function out = ctrldiscre(in)

%keyboard

NA = in(1);
apos = reshape(in(2:2*NA+1), NA, 2);
ctrlout = in(2*NA+2:3*NA+1);
M = in(end-1);
N = in(end);

hx = 1/M;
hy = 1/N;

out = zeros((M-1)*(N-1),1);
for i = 1:NA,
	i_pos = round(apos(i,1)/hx);	%convert actuator x coordination to integer between [0,M]
	j_pos = round(apos(i,2)/hy);	%convert actuator y coordination to integer between [0,N]
	if i_pos==0 || i_pos==M || j_pos==0 || j_pos==N,
		%if actuators are on the boundary, no control output
		continue;
	end
	out((j_pos-1)*(M-1)+i_pos) = ctrlout(i);
end



