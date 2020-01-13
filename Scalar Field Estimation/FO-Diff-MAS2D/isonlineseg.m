function out = isonlineseg(point, begin_point, end_point)
%isonlineseg: if a point is on a line segment 
%	point: [x,y], the point to be determined
%	begin_point: [x,y], beginning point of the line segment
%	end_point:	[x,y], ending point of the line segment
%	out: 1->is one the line segment ; 0->not not the line segment

%Author: Jinsong Liang
%Last modified: 07/31/2004

length_line = norm(begin_point-end_point);
length2begin = norm(point-begin_point);
length2end = norm(point-end_point);

if abs(length2begin+length2end-length_line) < 1e-10,
	out = 1;
else
	out = 0;
end

