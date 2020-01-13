% I have added this at the start to quickly test out github


function fcn_myPlot(x_all_time)
global A d n
num=5;
neighborMat=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
graycolor=[0.5 0.5 0.5];
markersize=30;
textsize=25;
finalcolor=[0 0 1]*0.8;
%
figure;
hold on; box on; axis equal
% set label and tick
fontsize=20;
set(gca, 'fontSize', fontsize)
set(get(gca, 'xlabel'), 'String', 'x', 'fontSize', fontsize);
set(get(gca, 'ylabel'), 'String', 'y', 'fontSize', fontsize);
% hide label and tick
% set(gca, 'xtick', [])
% set(gca, 'ytick', [])
% boxcolor=0.7*ones(1,3);
% set(gca, 'xcolor', boxcolor)
% set(gca, 'ycolor', boxcolor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot agent trajectory
for i=1:num
    xi_all=x_all_time.signals.values(:,2*i-1);
    yi_all=x_all_time.signals.values(:,2*i);
    plot(xi_all, yi_all, '--', 'color', graycolor);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial formation
% for i=1:num
%     for j=i+1:num
%         if neighborMat(i,j)==1
%             pi=x_all_time.signals.values(1,2*i-1:2*i)';
%             pj=x_all_time.signals.values(1,2*j-1:2*j)';
%             line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 2, 'color', graycolor);
%         end
%     end
% end
for i=1:num
    xi_init=x_all_time.signals.values(1,2*i-1);
    yi_init=x_all_time.signals.values(1,2*i);
    plot(xi_init, yi_init, 'o', 'MarkerEdgeColor', graycolor, 'MarkerFaceColor', graycolor, 'markersize', 10)
end
% plot circles and text: initial
for i=1:num
    xi_init=x_all_time.signals.values(1,2*i-1);
    yi_init=x_all_time.signals.values(1,2*i);
    plot(xi_init, yi_init, 'o', ...
        'MarkerSize', markersize,...
        'linewidth', 2,...
        'MarkerEdgeColor', graycolor,...
        'markerFaceColor', 'white');
    text(xi_init, yi_init, num2str(i),...
        'color', graycolor, 'FontSize', textsize, 'horizontalAlignment', 'center', 'FontName', 'times');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% final formation
for i=1:num
    for j=i+1:num
        if neighborMat(i,j)==1
            pi=x_all_time.signals.values(end,2*i-1:2*i)';
            pj=x_all_time.signals.values(end,2*j-1:2*j)';
            line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 2, 'color', finalcolor);
        end
    end
end
% plot circles and text: final
for i=1:num
    xi_init=x_all_time.signals.values(end,2*i-1);
    yi_init=x_all_time.signals.values(end,2*i);
    plot(xi_init, yi_init, 'o', ...
        'MarkerSize', markersize,...
        'linewidth', 2,...
        'MarkerEdgeColor', finalcolor,...
        'markerFaceColor', [1 1 1]);
    text(xi_init, yi_init, num2str(i),...
        'color', finalcolor, 'FontSize', textsize, 'horizontalAlignment', 'center', 'FontName', 'times');
end
% % intermediate formation
% for k=1:size(x_all_time.time,1)
%     for i=1:num
%         for j=i+1:num
%             if neighborMat(i,j)==1
%                 pi=x_all_time.signals.values(k,2*i-1:2*i)';
%                 pj=x_all_time.signals.values(k,2*j-1:2*j)';
%                 line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 1, 'color', rand(1,3));
%             end
%         end
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set limit
xlim=get(gca, 'xlim');
ylim=get(gca, 'ylim');
delta=0.2;
xlim=xlim+[-delta,delta];
ylim=ylim+[-delta,delta];
set(gca, 'xlim', xlim, 'ylim', ylim);
