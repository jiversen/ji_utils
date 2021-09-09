function [l, s] = plotShadedError(x,y,err,style,lw)
% plotShadedError  Plot curve with error range shaded underneath
%
% [l, s] = plotShadedError(x, y, err, [style],[lw])
%
%       x, y  basic curve
%       err     if size of y, error range is y +/- err
%               if 2 rows size of y, directly specifies top and bottom errors
%       style   traditional color letter (r, g, b or k) plus line style -or-
%                   [r g b] color (will use '-' line style)
%       lw      linewidth. default thick (1.2)
%
%       l, s    handles for line and shading
%
%   10/11/01 JRI

if nargin==0
    help plotShadedError
    return
end


%make x,y rows: 
x=x(:).';
y=y(:).';
%fix err shape
[r,c]=size(err);
if (r>c),
    err = err.';
end
[r,c]=size(err);
if ~(r==1 || r==2),
    error('err is wrong size')
end

if nargin < 4,
    style = 'b-';
end

if nargin < 5,
  lw = 1.2;
%   sec = 'none';
% else
%   sec = 'b';
end

sec = 'none'; %shading edge color

if ~isnumeric(style),
    bg = 0.3; %desaturate the shading color
    lc = [];
    switch style(1),
        case 'r'
            c=[1 bg/2 bg/2];
        case 'b'
            c=[bg bg 1];
        case 'g'
            c=[bg/2 1 bg/2];
        otherwise
            c=[.5 .5 .5];
    end

else
    lc = style.*0.9;     %line color (darken)
    c = style;
    %c = sqrt(lc);   %shading color (lighten)
    c(c==0) = 0.2;
    style = '-';
end
    
switch size(err,1),
    case 1,
        top = y+err;
        bot = y-err;
    case 2,
        top = err(1,:);
        bot = err(2,:);
end

xs = [x x(end:-1:1)];
ys = [top bot(end:-1:1)];
hold on

%temporary hack--intel beta doesn't have opengl support, so just draw lines, no
%patch
% if strcmp(computer,'MACI')
%     s = plot(xs,ys,style,'linewidth',0.25);
%     if ~isempty(lc),
%         set(s,'color',lc)
%     end
% else
    s = patch(xs,ys,c);
    set(s,'edgecolor',sec,'facealpha', 0.25);
% end

set(gcf,'renderer','opengl') %8/06 should happen automatically, lately it's not, so force
l = plot(x,y,style, 'linewidth', lw);
if ~isempty(lc),
    set(l,'color',lc)
end
