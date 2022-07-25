function whichdiff(fname, idx)
% whichdiff  utility to find diff between different versions of same file
% found on matlab path.
%
%   whichdiff mfilename
%       compares first two files listed using >> which -all mfilename
%
%   whichdiff(mfilename, indexes)
%       if which has multiple entries, can specify which two to compare
%           (indexes are into list returned by which)
%   
%
% 9/5/15 JRI

if nargin < 2
    idx = [1 2]; %default, compare first two
end

files = eval(['which(''-all'', ''' fname ''')']);

if isempty(files)
    disp([ fname ' was not found on path.'])
    return
end

if length(files)<2
  disp(['only one ' fname ' was found on path.'])
  disp(files{1})
  return
end

cmd = sprintf('diff -ubwBE ''%s'' ''%s''', files{idx(2)},files{idx(1)});
unix(cmd);
