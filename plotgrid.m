function hout = plotgrid(x,y_lim, y,x_lim, c, lw, style)
% plotGrid  Flexible plotting of grid lines
%
%   h = plotgrid(x,y_lim, y,x_lim, [c, lw, style])
%
% plots grid lines at values in x & y between y_lim & x_lim respectively
%   color c, linewidth lw and style may optionally be specified. 
%   light gray and 0.4 point solid lines are default.
%
%   if y_lim or x_lim are [], uses axis limits
%   if either x or y are [], don't draw any grids in that direction.
%
%   returns handles to grid lines
%
%   See also GRIDX, GRIDY.
%
% JRI 11/01

if nargin < 7,
    style = '-';
end
if nargin <6,
    lw = .4;
end
if nargin < 5,
    c = [.55 .55 .55];
end

if isempty(y_lim),
    y_lim = ylim;
end
if isempty(x_lim),
    x_lim = xlim;
end

hold on
hh = [];
for xg = x,
    h = plot([xg xg],y_lim,'color',c,'linewidth',lw,'linestyle',style);
    hh = [hh h];
end

for yg = y,
    h = plot(x_lim,[yg yg],'color',c,'linewidth',lw,'linestyle',style);
    hh = [hh h];
end

if nargout
    hout = hh;
end
