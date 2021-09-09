function xticklabel(xticks,xticklabels)
% xticklabel    replacement for setting xticklabels directly, allowing tex strings
%
%   xticklabel(xticks,xticklabels)
%
%   INPUTS
%       xticks       x-values for ticks
%       xticklabels  cell array of strings
%
%       if called w/o inputs, grabs current axis xtick and xticklabel props
%
%   JRI 10/31/05

% modified from: http://www.mathworks.com/support/solutions/data/1-15TK6.html?solution=1-15TK6
%   far simpler than xticklabel_rotate.m
%
%   improvements: no resizing of axes, labels aligned w/ original y position

if ~nargin,
    xticks = get(gca,'xtick');
    xticklabels = get(gca,'xticklabel');
end
fs = get(gca,'fontsize');
set(gca,'xtick',xticks);
yl = ylim;
ytext = yl(1) - 0.03*diff(yl); %match original labels precisely
t = text(xticks,ytext*ones(1,length(xticks)),xticklabels);
set(t,'HorizontalAlignment','center','VerticalAlignment','top',...
    'fontsize',fs);
%bogus: the following changes the size of the plot,
%set(gca,'xticklabel','')
%   instead, replace current labels w/ empty strings
for i = 1:length(xticklabels)
    emptylabels{i}=' ';
end
set(gca,'xticklabel',emptylabels)