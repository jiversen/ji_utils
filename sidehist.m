function [hout, nout, xout] = sidehist(data,histbins,x, dx, perc,total,doFilled)
% histoutline  Draw histogram in outline form vertically
%
%   [h, binheight, histbins] = sidehist(data,histbins,x, dx, perc,total,filled)
%
%       data        (ignores nan)
%       histbins    specifies bin centers
%       x           x position of 0 baseline (controls plot location)
%       dx          x scale of histogram (controls maximum plot 'height' in x direction)
%       perc        scale as percentage of total, if 0, actual counts
%       total       if specified, scale as percentage of this number
%       filled      if true, fills, false: outline
%
%   OUTPUTS
%       h           handle to plot object (patch or line)
%       binheight   height of histogram bins (in units specified)
%       histbins    histogram bin centers
%
%   JRI 7/15/04

histbinwidth = histbins(2)-histbins(1); %assume equal spacing

[n,xh] = hist(data, histbins);
%specify scaling--percentage of number of data points, or of total
if nargin>=6 && ~isempty(total),
    scalemax = total;
else
    scalemax = nanmax(data);
end
if nargin>4,
    if perc == 1,
        scalemax = 100;
        if nargin >= 6 && ~isempty(total),
            n=100*(n/total); %convert to percentage of total
        else
            n=100*(n/sum(~isnan(data))); %convert to percentage of total
        end
    end
end
if nargin <7,
    doFilled = false;
end

%setup bin edges, double up data heights
yy = sort([xh-histbinwidth/2 xh+histbinwidth/2]);
n_idx = round(0.5:0.5:length(n));
xx = n(n_idx);

xx = xx * (dx/scalemax) + ones(size(xx))*x; %scale appropriately
yy = yy(:)';
xx = xx(:)';
yy = [yy(1) yy yy(end)];
xx = [x xx x];
if doFilled,
    h = fill(xx,yy,'r');
else
    h = plot(xx,yy,'r-');
end

if nargout,
    hout = h;
    nout = n;
    xout = xh;
end
