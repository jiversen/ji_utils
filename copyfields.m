function dest = copyfields(src, dest, fnames, opt)
% copyfields copy a set of fields from one structure to another
%
%   dest = copyfields(src, dest, fieldnames, opt)
%
%       src         source struct (or vector of structs)
%       dest        destination struct
%       fieldnames  cell array of field names ([]: all fields)
%       opt         'preserve' will not overwrite already present fields
%                   default is to overwrite
%
%   if some of fieldnames aren't in source, simply skips them
%
%   JRI 9/23/08

if nargin==0,
    eval(['help ' mfilename])
    return
end

if ~any(size(src)==1),
  error('src must be a structure or 1-d structure vector')
end
nrec = length(src); %allow structure vectors

if nargin < 4 || ~strcmp(opt,'preserve'),
    overwrite = true;
else
    overwrite = false;
end

if nargin < 3 || isempty(fnames),
    fnames = fieldnames(src);
end

for i = 1:length(fnames),
    if ~isfield(dest,fnames{i}) || overwrite,
        try
          for j = 1:nrec,
            dest(j).(fnames{i}) = src(j).(fnames{i});
          end
        catch          
        end
    end
end
