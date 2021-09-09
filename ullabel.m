function h = ullabel(str,varargin)
% ULLABEL  Put a text label in upper left corner of a plot
%
%  ullabel(label) places label within figure pane. label can be string or scalar
%  ullabel(label,options) 
%       'outside'   places label to left of figure pane
%       'small'     small (7 pt) font size
%   h = ullabel...  returns handle to text object

%   good for figure pane id
%old: dx=.2; dy=-.15;

if nargin==0
    help ullabel
    return
end

if isnumeric(str),
    str = num2str(str);
end

dx=.12;
dy=-.02;
ha='left';
fs = 10;
fw = 'normal';

px = .05;
py = 0;


if nargin > 1,
    if strmatch_mixed('outside',varargin),
        dx=-.15;
        ha='right';
        py = 0.2;
    end
    if strmatch_mixed('small',varargin),
        fs=7;
    end
    if strmatch_mixed('bold',varargin),
        fw = 'bold';
%    else
%        error('ULLABEL: unknown option');
    end
end

ax=axis;
rangex = ax(2)-ax(1);
rangey = ax(4)-ax(3);
dx = rangex * px;
dy = rangey * py;
if strmatch_mixed('right',varargin),
    posx=ax(2)-dx;   
    ha = 'right';
else
    posx=ax(1)+dx;
end
posy=ax(4)+dy;

ho=text(posx,posy,str,'fontsize',fs,'fontweight',fw,...
    'horizontalalignment',ha,'verticalalignment','top');
if nargout,
    h=ho;
end
