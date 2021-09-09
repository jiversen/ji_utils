function info = fwhos(fname)
% fwhos   does whos on a file
%
%   [info =] fwhos(fname)
%   
%   just a shortcut for whos('-file',fname)
%
% JRI 9/8/09

global G

if nargin==0,
  eval(['help ' mfilename])
  return
end

if nargout,
  info = whos('-file',fname);
else
  whos('-file',fname);
end

