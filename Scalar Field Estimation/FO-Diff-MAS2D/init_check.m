if ~exist('PA0', 'var'),
	error('You have to initialize PA0 matrix.');
end

if ~exist('PS0', 'var'),
	error('You have to initialize PS0 matrix.');
end

if ~exist('VA0', 'var'),
	error('You have to initialize VA0 matrix.');
end


if ~exist('VS0', 'var'),
	error('You have to initialize VS0 matrix.');
end

%just to make later programming easier
if ~exist('BDD', 'var'),
	BDD = [];
end

if ~exist('BDN', 'var'),
	BDN = [];
end

if ~exist('PD0', 'var'),
	PD0 = [];
end

size_PA0 = size(PA0);
size_VA0 = size(VA0);
size_PS0 = size(PS0);
size_VS0 = size(VS0);
size_PD0 = size(PD0);

size_BDD = size(BDD);
size_BDN = size(BDN);

if size_PA0(1) ~= NA,
	error('NA and PA0 not consistent');
end

if size_VA0(1) ~= NA,
	error('NA and VA0 not consistent');
end

if size_PS0(1) ~= NS,
	error('NS and PS0 not consistent');
end

if size_VS0(1) ~= NS,
	error('NS and VS0 not consistent');
end

if size_PD0(1) ~= ND,
	error('ND and PD0 not consistent');
end

legend_str = {'initial actuator positions'; 'initial sensor positions'};
if ~isempty(BDD),
	legend_str{end+1} = 'Dirichlet boundary conditions';
end

if ~isempty(BDN),
	legend_str{end+1} = 'Neumann boundary conditions';
end

if ~isempty(PD0),
	legend_str{end+1} = 'Pollution source';
end

figure
plot(PA0(:, 1), PA0(:,2), 'o', PS0(:, 1), PS0(:, 2), 'x')
hold on
if ~isempty(BDD),
	plot([BDD(1, 1), BDD(1, 3)], [BDD(1, 2), BDD(1, 4)], 'k', 'linewidth', 1)
	text((BDD(1,1)+BDD(1,3))/2, (BDD(1,2)+BDD(1,4))/2, num2str(BDD(1,5)))
end

if ~isempty(BDN),
	plot([BDN(1, 1), BDN(1, 3)], [BDN(1, 2), BDN(1, 4)], 'r', 'linewidth', 1)
	text((BDN(1,1)+BDN(1,3))/2, (BDN(1,2)+BDN(1,4))/2, strcat('[', num2str(BDN(1,5)), ',', num2str(BDN(1,6)), ']'))
end

if ~isempty(PD0),
	plot([PD0(1, 1)], [PD0(1, 2)], 'r*')
end

legend(legend_str)

for i = 2:size_BDD(1),
	plot([BDD(i, 1), BDD(i, 3)], [BDD(i, 2), BDD(i, 4)], 'k', 'linewidth', 1)
	text((BDD(i,1)+BDD(i,3))/2, (BDD(i,2)+BDD(i,4))/2, num2str(BDD(i,5)))
end

for i = 2:size_BDN(1),
	plot([BDN(i, 1), BDN(i, 3)], [BDN(i, 2), BDN(i, 4)], 'r', 'linewidth', 1)
	text((BDN(i,1)+BDN(i,3))/2, (BDN(i,2)+BDN(i,4))/2, strcat('[', num2str(BDN(i,5)), ',', num2str(BDN(i,6)), ']'))
end

for i = 2:size_PD0(1),
	plot([PD0(i, 1)], [PD0(i, 2)], 'r*')
end
axis([-0.1, 1.1, -0.1, 1.1])
axis equal



