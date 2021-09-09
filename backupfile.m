function bfname = backupfile(filename)
% backupfile    Make a timestamped backup of any file (in same dir)
%
%   backupfile(filename)
%
%   JRI 9/15/05

if ~exist(filename,'file'),
    disp('backupfile: file not found')
    return
end

[junk,stamp]=timestamp;
[path,name,extension] = fileparts(filename);
backupfilename = fullfile_mkdir(path,'~backups',[name '_' stamp '_backup' extension]);

cname = computer;
switch cname(1:2),
    case 'PC',
        cmd = sprintf('copy "%s" "%s"', filename, backupfilename);
    otherwise
        cmd = sprintf('cp "%s" "%s"',   filename, backupfilename);
end

[status, result] = system(cmd);
if status,
    disp(['backupfile: ' result])
end

if nargout,
    bfname = backupfilename;
end