function vars = fvars(fname)
%fvars  return variables contained in a .mat file
%
%   vars = fvars(fname)
%
% JRI 9/8/09

if nargin==0,
  eval(['help ' mfilename])
  return
end

info = whos('-file',fname);
vars = {info(:).name};

