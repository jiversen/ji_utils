function hout = plotMeanMarker(data, weights, idx, color, show_mean, weight_mean)
%plotMeanMarker  show triangular marker marking the mean
%
%    hout = plotMeanMarker(data, weights, idx, color, show_mean, weight_mean)
%
%       data
%       idx     optional subset of data to use for mean/median, use [] for all data
%       weights weights for data points
%   

if nargin == 1,
  show_mean = true;
  weight_mean = false;
  color = 'k'
  idx = [];
end

y_lim = ylim;
x_lim = xlim;
yw = diff(y_lim);
xw = diff(x_lim);
scale = [0.01 0.03]; %proportion of axis scale

%want our arror to appear 'square' so need the axis position in pixels to do it properly
fp = get(gcf,'position');
ap = get(gca,'position');
aspect = (ap(3)*fp(3)) / (ap(4)*fp(4)); % x:y


trix = [-1 1 0 -1] * xw * scale(1) / aspect; %define marker for mean
triy = [0 0 -1 0] * yw * scale(2) + y_lim(2)-scale(1)*yw;

%extract subset of data for mean (defined by idx)
if isempty(idx), idx = 1:length(data); end
data = data(idx);
if ~isempty(weights),
    dataWeights = weights(idx);
end

%pick which quantity to display
if show_mean,
    if weight_mean,
        m = nansum(data.*dataWeights) / sum(dataWeights);
    else
        m = nanmean(data);
    end
    h = patch(trix+m, triy, color);
else
    m = nanmedian(data);
    h = patch(trix+m, triy, color);
end

set(h,'edgecolor','none') %but in ILL, add .5 pt edge to the filled triangle

if nargout,
    hout = h;
end
