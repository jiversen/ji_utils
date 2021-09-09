function hout = xyline(slope)
% xyline draw line x=y on current figure
%
%   xyline(slope) draw line with given slope (all intercepts=0)

if nargin < 1,
    slope = 1;
end

hold on
ax = axis;
lowx = max(ax([1 3]));
lowy = lowx;
hix  = min(ax([2 4]));
hiy  = hix;

if slope < 1,
    hiy = hiy * slope;
elseif slope > 1,
    hix = hix / slope;
end

h = plot([lowx hix], [lowy hiy], 'k:');
if nargout,
    hout = h;
end