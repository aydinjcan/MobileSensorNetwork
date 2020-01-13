function [bndtype, bndpara] = bndsearch(point, BDD, BDN)
%bndtype: return the boundary condition type of a point
%	point: [x,y], coordination of the point
%	BDD: Dirichlet boundary condition matrix
%	BDN: Newmann boundary condition matrix
%	bndtype: 0->not a boundary point, 1->Dirichlet boundary condition, 2->Newmann boundary condition
%	bndpara: bndtype=0->bndpara=[]; bndtype=1->bndpara=c; bndtype=2->bndpara=[c1, c2]

%Author: Jinsong Liang
%Last modified: 07/30/04

%initial assumption
bndtype = 0;
bndpara = [];

size_BDD = size(BDD);
size_BDN = size(BDN);

for i = 1:size_BDD(1), %looping through the rows
	if isonlineseg(point, BDD(i,1:2), BDD(i, 3:4)),
		bndtype = 1;
		bndpara = BDD(i, 5);
		break;
	end
end

if bndtype==0, %not Dirichlet boundary
	for i = 1:size_BDN(1),
		if isonlineseg(point, BDN(i,1:2), BDN(i, 3:4)),
			bndtype = 2;
			bndpara = BDN(i, 5:6);
			break;
		end
	end
end
