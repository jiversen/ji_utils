function [nout, xout, hout] = jihist(data, varargin)
% jihist    more powerful histogram analysis/plotting
%
%   basic form is like hist (bins are bin centers).
%       [n, x] = jihist(data, [bins]);
%
%   Add param, value pairs to change behavior. 
%        [n, x] = jihist(data, [bins], param1, value1, ...);
%
%   Return handle to plotted object.
%       [n, x, h] = jihist(...
%
%       Main things added to standard hist are 1) normalization of histogram 
%       values: express as % of sample, or % or a larger sample of which we're
%       showing a subset, 2) weighting of values, 3) control of plot style, 
%       including plotting just an outline only (e.g. to overlay a second historgram)
%
%   params      values      description
%
% Analysis options
%   normalize   [none]      plot % of count if specified (implied if normidx given)
%   scale       [scalar]    scale counts by this, default 1 (e.g. 100 show percent)
%   weights     [vector]    weight elements in data by this, default: no weighting
%   idx         [vector]    evaluate only elements in data(idx), default: all
%   normidx     [vector]    normalize by this set of elements of data, default: all
%                            if no weights, normalize by length of normidx
% Plot options
%   noplot      [none]      do not plot if specified
%   outline     [none]      draw outline if specified, else standard bars
%   color       [colorspec] color for bar fill or outline (can also be [r g b])
%   linewidth   [scalar]    width of outline
%   linestyle   [linestyle] line style for outline
%   mark        [string]    place marker at 'mean' or 'median'
%   number      [none]      label each bar with its height
%
%   example
%
%       jihist(a)
%       jihist(b,'outline')
%
%   %compare two subsets of a larger dataset
%       data = randn(1000,1);subset1 = 1:500; subset2 = 501:1000;
%       bins = -4:0.25:4;
%       hold on
%       n1 = jihist(data,bins,'idx',subset1, 'normidx', 1:length(data), 'scale', 100)
%       n2 = jihist(data,bins,'idx',subset2, 'normidx', 1:length(data), 'scale', 100, 'outline')
%       sum(n1) + sum(n2) %equals 100%
%       
%   4/6/07  JRI (iversen@nsi.edu)
%
%   

if ~nargin,
    help jihist
    return
end

%handle bins
if length(varargin) < 1 || ischar(varargin{1}), %default bins
    bins = 10; %same default as in hist
elseif isnumeric(varargin{1}), %grab bins, if specified
    bins = varargin{1};
    varargin(1) = [];
end

idx         = getparam('idx',       varargin, 1, 1:length(data));
normidx     = getparam('normidx',   varargin);
doNormalize =  isparam('normalize', varargin) || ~isempty(normidx);
weights     = getparam('weights',   varargin);
noplot      =  isparam('noplot',    varargin);
doOutline   =  isparam('outline',   varargin);
if doOutline, colorDef = 'r'; else colorDef = 'k'; end %default color r for outline, k for bars
color       = getparam('color',     varargin, 1, colorDef);
linewidth   = getparam('linewidth', varargin, 1, 2);
linespec    = getparam('linestyle', varargin, 1, '-');
scale       = getparam('scale',     varargin, 1, 1);
mark        = getparam('mark',      varargin, 1, []);
doNumber    =  isparam('number',   varargin);


doWeight = ~isempty(weights);

if doWeight
    require(all(size(data) == size(weights)), 'weights must be same size as data')
end

%calculate normalization (first, before extracting plotting subset)
if doNormalize
    if isempty(normidx)
        normidx = idx;
    end
    require(length(normidx) <= length(data), 'normalization indices must fit within data')
    if doWeight
        norm = sum(weights(normidx));       %proportion of total weight
    else
        norm = sum(~isnan(data(normidx)));  %proportion of total N
    end
else
    norm = 1;                               %Unnormalized
end

%add scaling (in denom since we calculate n' = n / norm ;
norm = norm / scale;

%extract subset to display
data = data(idx);

%calculate
if doWeight
    weights = weights(idx);
    [n, x] = whist(data,weights,bins);
else
    [n, x] = hist(data,bins);
end

%normalize
n = n / norm;


%plot
%save, restore y limit
yl = ylim;
ymanual = strcmp(get(gca,'ylimmode'),'manual');

if ~doOutline
    h=bar(x,n,'hist');
    set(h,'facecolor',color,'edgecolor','none'); %then in ILLUSTRATOR, add 0.5 pt wide edge to bars!
else
    h = baroutline(x,n); %outline of bars
    set(h,'color',color,'linestyle',linespec,'linewidth',linewidth);
end

box off

if ymanual
  ylim(yl)
end

yrange = diff(ylim);

%number
if doNumber
    for i = 1:length(x)
        if (n(i) > 0)
            text(x(i),n(i) + yrange/30,num2str(n(i)),'verticalalignment','bottom','horizontalalignment','center')
        end
    end
end

%mark
if ~isempty(mark)
  switch mark
    case 'mean'
      plotMeanMarker(data,weights,[],color,true,doWeight);
    case 'median'
      plotMeanMarker(data,[],[],color,false,false);
    otherwise
      error('incorrect value for mark parameter')
  end
end

if nargout >= 1
    nout = n;
end
if nargout >= 2
    xout = x;
end
if nargout >= 3
    hout = h;
end
