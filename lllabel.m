function h = lllabel(str,varargin)
% LLLABEL  Put a text label in lower left corner of a plot
%
%  lllabel(label) places label within figure pane. label can be string or scalar
%  lllabel(label,options) 
%       'outside'   places label to left of figure pane
%       'small'     small (6) font size
%   h = lllabel...  returns handle to text object

if isnumeric(str),
    str = num2str(str);
end

ha='left';
fs = 12;

px = .05;
py = .05;

if nargin > 1,
   if strmatch_mixed('outside',varargin),
      dx=-.15;
      ha='right';
   end
   if strmatch_mixed('small',varargin),
       fs=7;
   else
      error('LLLABEL: unknown option');
   end
end

ax=axis;
rangex = ax(2)-ax(1);
rangey = ax(4)-ax(3);
dx = rangex * px;
dy = rangey * py;

posx=ax(1)+dx;
posy=ax(3)+dy;
h=text(posx,posy,str,'fontsize',fs,'horizontalalignment',ha,'verticalalignment','middle');
