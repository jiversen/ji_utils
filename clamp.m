function x = clamp(x,lim)
% clamp clamp to limits
%
%   x = clamp(x,[lo hi])
%
% JRI 8/18/10

if nargin==0,
  eval(['help ' mfilename])
  return
end

x(x<lim(1)) = lim(1);
x(x>lim(2)) = lim(2);


