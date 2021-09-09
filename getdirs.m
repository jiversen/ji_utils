function dirs = getdirs(path)
% getdirs  return only directories within a path, same format as dir
%
% JRI 7/29/08
% JRI 10/18/10 bugfix-relied on . & .. being first in list, will fail if have a
%   file starting with a space

all = dir(path);
if isempty(all),
    dirs = [];
    return
end
isdir = [all(:).isdir];
dirs = all(isdir);
names = {dirs(:).name};
excludeIdx = strmatch('.',names); %NB exlude _anything_ starting with a .
dirs(excludeIdx) = [];

