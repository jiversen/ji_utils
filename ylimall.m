function ylimall(yl, tag)
% ylimall make ylim of all axes in a figure the same
%
%   ylimall           set all ylims to maximum ylim
%   ylimall([],tag)   same, but only for axes matching tag
%   ylimall(yl)       set all ylims to yl (either [min max] or 'auto')
%   ylimall(yl, tag)  same, but only for axes matching tag

%   
%
% JRI 10/15/10

if nargin < 2,
  ax = findobj(gcf,'type','axes');
else
  ax = findobj(gcf,'type','axes','tag',tag);
end

% no lims specified, walk axes and find extreme values
if nargin==0 || isempty(yl),
  yl = [nan nan];
  for a = ax',
    tmp = ylim(a);
    yl(1) = nanmin(tmp(1),yl(1));
    yl(2) = nanmax(tmp(2),yl(2));
  end
end

% walk axes, setting ylims
for a = ax',
  ylim(a,yl)
end



