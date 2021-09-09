function [dxout, dy, len, ang] = d
% d  measure distances on plot
%
% [dx, dy, len, angle] = d
%
% click on two points, return to abort

legh = legend;
if ~isempty(legh),
  legend hide
end

[x,y] = ginput(2);

if length(x) < 2, return, end

dx = diff(x);
dy = diff(y);
len = sqrt(dx*dx + dy*dy);
ang = atan(dy/dx);

if ~nargout,
  fprintf(' dx=%s (%s Hz), dy=%s, len=%s, angle=%s, slope=%s\n', ...
    num2str(dx,4),num2str(1/dx,3),num2str(dy,4),...
    num2str(len,4), num2str(ang*180/pi,3), num2str(dy/dx,4));
else
  dxout = dx;
end

if ~isempty(legh),
  legend show
end