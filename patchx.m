function hout = patchx(fromx, tox, c, a, y_lim)
%  patchx   plot shaded patches on plot
%
%   h =patchx(fromx, tox,[c], [a], [yl])
%
%       plots light gray patches between fromx and tox
%           w/ y limits equal to current ylim
%
%       if fromx, tox are vectors, plots multiple patches
%
%       c   color [r g b] or letter
%       a   alpha (default 0.2)
%       yl  alternate ylimits (by default matches ylimit of axis)
%
% JRI 7/20/04

if nargin == 0
  help patchx
  return
end

if ~exist('c','var')
    c = [0 0 0];
end

if ~exist('a','var')
  a = 0.2;
end

if ~exist('y_lim','var')
    y_lim = ylim;
end

top = y_lim(2);
bot = y_lim(1);

hands = [];
for r = 1:length(fromx) %plot a grey patch for gallop epochs
    l = fromx(r);
    r = tox(r);
    if any(isnan([l r])), continue, end
    patch_x = [l r r l l];
    patch_y = [top top bot bot top];
    h = patch(patch_x,patch_y,c,'edgecolor','none', 'facealpha',a,'clipping','off');
    hands = [hands h]; %collect list of patch handles
end

if nargout
    hout = hands;
end