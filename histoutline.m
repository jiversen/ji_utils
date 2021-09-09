function hout = histoutline(data,histbins,perc,total)
% histoutline  Draw histogram outline
%
%   h = histoutline(data,histbins,[perc],[n])
%
%   INPUTS
%       data are placed at bin centers specified by histbins.
%       if histbins is scalar, specifies # of bins
%       if perc = 1, plot as percentage of total number of observations
%       if perc = 1 and n is specified, plot percentage normalized by n 
%       (useful for putting
%           several histograms onto the same normalized scale)
%
%   OUTPUT
%       h is handle to line
%
%   JRI 7/15/04


[n,x] = hist(data, histbins);
histbinwidth = x(2)-x(1); %assume equal spacing

if nargin>2,
    if nargin == 3,
        n=100*(n/sum(n)); %convert to percentage of total
    else
        n=100*(n/total); %convert to percentage of total
    end
end
%setup bin edges, double up data heights
xx = sort([x-histbinwidth/2 x+histbinwidth/2]);
n_idx = round(0.5:0.5:length(n));
yy = n(n_idx);
h = plot(xx,yy,'r-');

if nargout,
    hout = h;
end
