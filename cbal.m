function cbal(lim)
% cbal balance clim of plot
%
%   if axis limits span 0, makes +/- symmetric
%
%   cbal(lim): create symmetric (round 0) axis with limit lim
%
% forces hotcold colormap



%if prod(yl) < 0, %spans zero
if nargin,
  m = lim;
else
  yl=caxis;
  m=niceround(max(abs(yl)),-1);
end
caxis(m*[-1 1])
colormap hotcold
%colormap redwhiteblue %better on printer
%brighten(-.8)
%jicolorbar
%end