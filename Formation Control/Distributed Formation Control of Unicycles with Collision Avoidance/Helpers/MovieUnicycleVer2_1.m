%% Unicycle animation
%
% This script plots the unicycle trajectories that are computed in 
% the simulation.
%
% Ver 2_1: 
%           - Uses angles as state 
%
function MovieUnicycleVer2_1(fileName, plotParam)

adj     = plotParam.adj;
N       = plotParam.N;
state   = plotParam.stateMat;
trace   = plotParam.trace;
vidFrameRate = plotParam.vidFrameRate; 	% Video frame rate
vidQuality   = plotParam.vidQuality;    % Video quality


%% Folder to save the figure

currentFolder   = pwd;
address         =  strcat(currentFolder,'\SavedFigs\');


%% Parameters

% Size of agents on the plot
blobSize = 100;
scale = 2.5;            % Size of the unicycle on the plot

% x and y margins in the figure
xMargin = 0.3;
yMargin = 0.3;

% Name and address of the video file
fileType = '.avi';
fullAddress = strcat(address,fileName,fileType);

% Video settings
vid = VideoWriter(fullAddress);
vid.Quality     = vidQuality;      % A value between 0 to 100
vid.FrameRate   = vidFrameRate;
% set(gcf,'Renderer','zbuffer');

% Color map:
cmap = repmat([255, 68, 0]./255, N,1);


%% Locus Movie

sizeFig = [10 8];
position = [2 2, sizeFig];
figure('Units', 'inches', 'Position', position);
axis square
box on

% Adjust axis position in the figure
axPos = get(gca,'Position');
set(gca,'Position',axPos+[0.0 0.03 0.0 0.0])

% Start recording
open(vid);

% x-y positions
X = state(:,1:2:(2*N-1));          
Y = state(:,2:2:(2*N));

% Heading angles
Theta = state(:,2*N+1:3*N);

% Number of iterations (movie frames)
itrTot = size(X,1);  

for itr = 1 : itrTot
    itr
    hold on
    
    % Plot initial positions as circles
    for i = 1 : N
        if (itr ~= 1) && (itr < trace) 
            scatter(X(1,i),Y(1,i),blobSize,cmap(i,:),...
                'MarkerEdgeColor',cmap(i,:), 'LineWidth',2);
        end
    end
    
    % Plot trajectories
    for i = 1 : N
        jMin = max(1,itr-trace);
        for j = jMin : itr-1
            plot(X(j:j+1,i),Y(j:j+1,i),...
                'Color',cmap(i,:),'LineWidth',3); 
        end
    end
    
    % Plot graph Adjacency 
    for m = 1 : N
        for n = 1 : N
            if adj(m,n)
            plot([X(itr,m),X(itr,n)],[Y(itr,m),Y(itr,n)], ...
                 'LineWidth',2,...
                 'Color', [0.7 0.7 0.7]);
            end
        end
    end
    
    % Plot unicycles and number them
    for i = 1 : N
        % Draw unicycle
        DrawUnicycle([X(itr,i),Y(itr,i), Theta(itr,i)], scale);

        % Number agents at current location
        strNums = strtrim(cellstr(num2str(i,'%d')));
        text(X(itr,i),Y(itr,i),strNums, ...
            'color', [1,1,1],                 ...
            'VerticalAlignment','middle',     ...
            'HorizontalAlignment','center',   ...
            'FontWeight','demi','FontSize',22,...
            'FontName'   , 'Times New Roman'     );
    end

    
    %%
    
    % Adjust axis margins
    set(gca, 'XLimMode', 'auto');
    set(gca, 'YLimMode', 'auto');
    axis equal
    xLim = get(gca,'XLim');    
    yLim = get(gca,'YLim');    
    set(gca, 'XLim', xLim + [-xMargin, xMargin]);
    set(gca, 'YLim', yLim + [-yMargin, yMargin]);        
    
    % Label
    hXLabel = xlabel('x','FontWeight','demi');
    hYLabel = ylabel('y','FontWeight','demi');
    
    % Adjust Font and Axes Properties
    hAx = gca;
    set( gca                             , 'FontName'   , 'Times New Roman' );
    set([hXLabel, hYLabel]               , 'FontName'   , 'Times New Roman' );
    set([hAx]                            , 'FontSize'   , 21                );
    set([hXLabel]                        , 'FontSize'   , 22                );
    set([hYLabel]                        , 'FontSize'   , 22                );

    hold off
    drawnow
    
    % Write video frame
    writeVideo(vid, getframe(gcf));
    
    % Clear axes
    if itr ~= itrTot(end), cla, end  % Do not wipe the last frame
end

% Stop recording
close(vid);























































