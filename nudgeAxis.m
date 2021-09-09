function nudgeAxis(xnudge, ynudge)
% nudgeAxis Shift axis position
%
% nudgeAxis(dx,dy) dx, dy in normalized fig units

if nargin==0,
  eval(['help ' mfilename])
  return
end

pos = get(gca,'position');
pos(1) = pos(1)+xnudge;
pos(2) = pos(2) + ynudge;
set(gca,'position',pos);
