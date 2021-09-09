function hout = baroutline(x, y)
% baroutline  Draw outline of a bar plot (useful for histograms) 
%
%   h = baroutline(x, y)
%
%   plot outline of a histogram, with bars height y, centered on values in x.
%   Returns h, handle to line object. Does not draw line for bars of zero height
%
%   should produce same output as if bar(n,x,'hist') had been called
%
%   See also JIHIST
%
%   JRI 7/15/04

histbinwidth = x(2)-x(1); %assume equal spacing

%setup bin edges, double up data heights
xx = sort([x-histbinwidth/2 x+histbinwidth/2]);
y_idx = round(0.5:0.5:length(y));
yy = y(y_idx);

xx = [xx(1) xx xx(end)]; %make outline go to zero at edges
yy = [0 yy 0];

%no lines drawn for bins of zero height
iZero = find(yy==0);
dy = [1 diff(iZero) 1];
baddy = (dy(1:end-1)==1 & dy(2:end) == 1);
iZap = iZero( find(baddy) ); %get rid of zeros within spans of zero
yy(iZap) = nan;
xx(iZap) = nan;

h = plot(xx,yy,'r-');

if nargout,
    hout = h;
end
