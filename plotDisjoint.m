function hout = plotDisjoint(x,y,idx,varargin)
%  plotDisjoint  Plot disjoint segments of a curve
%
%   h = plotDisjoint(x,y,idx,varargin)
%
%       plot points x,y indexed by idx (subset of full vectors)
%           breaking up disconnected segmennts
%
%       other args same as for plot
%
%   JRI 7/20/04

idx = idx(:)';
x = x(:)';
y = y(:)';
x = x(idx);
y = y(idx);

iStart  = find(diff([-1 idx]) > 1); %index of segment starts

for i = length(iStart):-1:2, %loop, insert NaN(line break) before each start
    x = [x(1:iStart(i)-1) NaN x(iStart(i):end)];
    y = [y(1:iStart(i)-1) NaN y(iStart(i):end)];   
end

if nargin > 3,
    h = plot(x,y,varargin{:});
else
    h = plot(x,y);    
end

if nargout,
    hout = h;
end