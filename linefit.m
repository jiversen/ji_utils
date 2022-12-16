function str = linefit(X,Y, order)
% linefit draw best fit line and show stats
%
%   str = linefit(X,Y)
%
%
% JRI 2/7/12

if nargin==0
  eval(['help ' mfilename])
  return
end

if nargin < 3
  order = 1;
end

Xr = [X(:) ones(size(X(:)))]; %include constant term in regressions
Y = Y(:);
if order>=2
  Xr = [X(:).^2 Xr]; %add quadratic term
end
if order == 3
   Xr = [X(:).^3 Xr]; %add cubic term
end

%lsline
[b,bint,rr,rint,stats] = regress(Y,Xr);
str = sprintf('R^2 = %.3f, %s', stats(1), sigStr(stats(3)));
h = refline(b);
set(h,'color',[.1 .1 .1])

if ~nargout
  ullabel(str)
end