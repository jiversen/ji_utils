function [hhd, hhe] = jierrorbar(x, y, l,u,symbol,barwidth,mode)
%  JIERRORBAR Error bar plot. Fixed ERRORBAR to enable proper legends (JRI 12/01)
%
%   [hhd, hhe] = jierrorbar(x, y, l, u, symbol, barwidth, mode)
%
%   ERRORBAR(X,Y,L,U) plots the graph of vector X vs. vector Y with
%   error bars specified by the vectors L and U.  L and U contain the
%   lower and upper error ranges for each point in Y.  Each error bar
%   is L(i) + U(i) long and is drawn a distance of U(i) above and L(i)
%   below the points in (X,Y).  The vectors X,Y,L and U must all be
%   the same length.  If X,Y,L and U are matrices then each column
%   produces a separate line.
%
%   ERRORBAR(X,Y,E) or ERRORBAR(Y,E) plots Y with error bars [Y-E Y+E].
%   ERRORBAR(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  See PLOT for possibilities.
%
%   [HD, HE] = ERRORBAR(...) returns a vector of line handles to data and error bars
%                 
%           *JRI changed to make legends work: pass hd to legend command. 
%                  (Before, legend would annotate both data and errorbars.)
%               added 'barwidth' the width of the 'T' on the error bar
%                   as a proportion of the span of x: Twidth = barwidth * (xmax-xmin)
%                   if not specified, defaults to original
%               added 'mode' to control how error bars are drawn
%                   possible values are 
%                   'both' (default) above and below point
%                   'up' above point
%                   'down' below
%                   'sign' away from 0 (best for barplots)
%   example:
%       [hd, he] = jierrorbar(x, y, sd, plotstyle,barwidth);
%       set(he,'linewidth',2)
%       legend(hd, ...)
%


%   L. Shure 5-17-88, 10-1-91 B.A. Jones 4-5-93
%   Copyright 1984-2000 The MathWorks, Inc. 
%   $Revision: 5.17 $  $Date: 2000/06/02 04:30:46 $

if min(size(x))==1,
  npt = length(x);
  x = x(:);
  y = y(:);
    if nargin > 2,
        if ~isstr(l),  
            l = l(:);
        end
        if nargin > 3
            if ~isstr(u)
                u = u(:);
            end
        end
    end
else
  [npt,n] = size(x);
end

if nargin == 3
    if ~isstr(l)  
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = y;
        u = y;
        y = x;
        [m,n] = size(y);
        x(:) = (1:npt)'*ones(1,n);;
    end
end

if nargin >= 4
    if isstr(u),     
        if nargin >= 6,
            mode = barwidth;
        end
        if nargin >= 5,
            barwidth = symbol;
        end
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargin == 2
    l = y;
    u = y;
    y = x;
    [m,n] = size(y);
    x(:) = (1:npt)'*ones(1,n);;
    symbol = '-';
end

if ~exist('barwidth','var'),
    barwidth = .02;
end
if ~exist('mode','var'),
    mode = 'both';
end

u = abs(u);
l = abs(l);
    
if isstr(x) | isstr(y) | isstr(u) | isstr(l)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(l)) | ~isequal(size(x),size(u)),
  error('The sizes of X, Y, L and U must be the same.');
end

tee = barwidth * (max(x(:))-min(x(:)))/2;  % specified width
%tee = (max(x(:))-min(x(:)))/100;  % make tee .02 x-distance for error bars
xl = x - tee;
xr = x + tee;
ytop = y + u;
ybot = y - l;
n = size(y,2);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

%create masks to delete (set to NaN) various bars
%JRI
switch mode
    case 'both'
        upmask = ones(size(y));
        downmask = ones(size(y));
    case 'up'
        upmask = ones(size(y));
        downmask = NaN*ones(size(y));
    case 'down'
        upmask = NaN*ones(size(y));
        downmask = ones(size(y));        
    case {'sign', 'negsign'}
        s = sign(y);
        if strcmp(mode,'negsign'),
            s = -s;
        end
        upmask = ones(size(y));
        upmask(s<0) = NaN;
        downmask = ones(size(y));
        downmask(s>0) = NaN;
end

% build up nan-separated vector for bars
xb = zeros(npt*10,n);
xb(1:10:end,:) = x;
xb(2:10:end,:) = x;
xb(3:10:end,:) = x;
xb(4:10:end,:) = NaN;
xb(5:10:end,:) = xl;
xb(6:10:end,:) = xr;
xb(7:10:end,:) = NaN;
xb(8:10:end,:) = xl;
xb(9:10:end,:) = xr;
xb(10:10:end,:) = NaN;

yb = zeros(npt*10,n);
yb(1:10:end,:) = ytop .* upmask;
yb(2:10:end,:) = y;
yb(3:10:end,:) = ybot .* downmask;
yb(4:10:end,:) = NaN;
yb(5:10:end,:) = ytop .* upmask;
yb(6:10:end,:) = ytop .* upmask;
yb(7:10:end,:) = NaN;
yb(8:10:end,:) = ybot .* downmask;
yb(9:10:end,:) = ybot .* downmask;
yb(10:10:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

he = plot(xb,yb,esymbol); hold on
hd = plot(x,y,symbol); 

if ~hold_state, hold off; end

if nargout>0, hhd = hd; hhe = he; end
