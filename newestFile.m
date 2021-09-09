function fname = newestFile(template)
% newestFile find newest file matching a template
%
%   fname = newestFile(template)
%
%   template is a full path, with wildcard. fname returns newest file matching template
%
%

pathstr = fileparts(template);

files = dir(template);
[~,use] = max([files.datenum]);

fname = fullfile(pathstr, files(use).name);
