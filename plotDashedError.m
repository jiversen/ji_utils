function [l, s] = plotDashedError(x,y,err,style)
% plotDashedError  Plot curve with error range dashed above and below
%
% [l, s] = plotDashedError(x, y, err, [style])
%
%       x, y  basic curve
%       err     if size of y, error range is y +/- err
%               if 2 rows size of y, directly specifies top and bottom errors
%
%       l, s    handles for line and upper/lower dashed lines
%
%   10/11/01 JRI

c=[1 0 0];

if nargin < 4,
    style = 'b-';
end
switch size(err,1),
case 1
    top = y+err;
    bot = y-err;
    
case 2
    top = err(1,:);
    bot = err(2,:);
end
xs = [x x(end:-1:1)];
ys = [top bot(end:-1:1)];
hold on
st = line(x,top,'color',c,'linestyle',':');
sb = line(x,bot,'color',c,'linestyle',':');
s = [st sb];
l = plot(x,y,style);
