function hout = patchx(fromx, tox, c, a)
%  patchx   plot shaded patches on plot
%
%   h =patchx(fromx, tox,[c], [a])
%
%       plots light gray patches between fromx and tox
%           w/ y limits equal to current ylim
%
%       if fromx, tox are vectors, plots multiple patches
%
%       c is color (default 80% gray)
%       a is alpha (default 0.2)
%
% JRI 7/20/04

if nargin == 0,
  help patchx
  return
end

if nargin < 3
    c = 0.8 * [1 1 1];
    c = [0 0 0];
end

if nargin < 4
  a = 0.2;
end

y_lim = ylim;
top = y_lim(2);
bot = y_lim(1);

hands = [];
for r = 1:length(fromx) %plot a grey patch for gallop epochs
    l = fromx(r);
    r = tox(r);
    if any(isnan([l r])), continue, end
    patch_x = [l r r l l];
    patch_y = [top top bot bot top];
    h = patch(patch_x,patch_y,c,'edgecolor','none', 'facealpha',a);
    hands = [hands h]; %collect list of patch handles
end

if nargout,
    hout = hands;
end