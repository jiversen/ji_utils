function f = fullfile_mkdir(varargin)
% FULLFILE_MKDIR Build full filename from parts. Ensure all subdirs exist. Mkdir if not.
%   
%   This is an extension of standard FULLFILE
%
%   FULLFILE_MKDIR(D1,D2, ... ,FILE) builds a full file name from the
%   directories D1,D2, etc and filename FILE specified.  This is
%   conceptually equivalent to
%
%      F = [D1 filesep D2 filesep ... filesep FILE] 
%
%   except that care is taken to handle the cases where the directory
%   parts D1, D2, etc. may begin or end in a filesep. Specify FILE = ''
%   to build a pathname from parts.
%
%   *Additionally, if any subdirectories of D1 (i.e. D1/D2, D1/D2/D3...) do not exist
%   create them, to guarantee that the full path exists. Use this
%   before writing files to ensure that they can be saved successfully.
%   (Added 9/17/02 JRI)
%
%   Examples
%     To build platform dependent paths to files:
%        fullfile(matlabroot,'toolbox','matlab','general','Contents.m')
%
%     To build platform dependent paths to a directory:
%        addpath(fullfile(matlabroot,'toolbox','matlab',''))
%
%   See also FULLFILE, FILESEP, PATHSEP, FILEPARTS.

%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 1.17 $ $Date: 2001/04/15 12:02:22 $
%   Mkdir added 9/17/02 by JRI

if nargin<2, error('Not enough input arguments.'); end
fs = filesep;

paths = varargin;
narg = nargin;

f = split(paths{1},fs);
if isempty(f{1})
  f(1)=[];
  f{1} = [fs f{1}];
end
if length(f) > 1
  paths(1)=[];
  paths = [f paths];
end
f = paths{1}; %base directory
narg = length(paths);

% Be robust to / or \ on PC
if strncmp(computer,'PC',2)
   f = strrep(f,'/','\');
end

for i=2:narg-1 %loop over subdirectories (don't include final file name)
   part = paths{i};
   parent = f;
   if isempty(f) || isempty(part)
      f = [f part];
   else
      % Handle the three possible cases
      if (f(end)==fs) && (part(1)==fs)
         f = [f part(2:end)];
      elseif (f(end)==fs) || (part(1)==fs)
         f = [f part];
      else
         f = [f fs part];
      end
   end
   make_if_necessary(f, parent, part);
end
%add filename to end if there is one
if ~isempty(varargin{end})
    f = [f fs varargin{end}];
end

%^nice, but omit to keep consistent with normal fullfile
if 0
    % Make sure a directory path ends in a fs on a MAC [& PC: though not necessary, I like it]
    if ( strncmp(computer,'MAC',3) | strncmp(computer,'PC',2) ) ...
            & isempty(varargin{end}) & f(end)~=fs
        f = [f fs];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function make_if_necessary(path, parent, subdir)
% test if path exists, make if not. Assumes that parent directory already exists

if ~exist(path,'dir')
    if isempty(parent) %a relative directory, create in current
        disp(['Creating subdir: ' subdir ' in current dir (' pwd ')']);
        mkdir(subdir);
    else
        disp(['Creating subdir: ' subdir ' in ' parent]);
        mkdir(parent, subdir);
    end
end

function pieces = split(str,delimiter)
% split split a string on an arbitrary delimiter
%
%   pieces = split(str,delimeter)
%
%   str is a string, delimiter is a string used to break str into pieces. 
%   delimiter can include standard fprintf codes, e.g. \t or \n, 
%   but note a multi-char delimiter must match ALL characters in sequence.
%
%   returns cell array of split pieces
%
%   str can also be a cell array of strings, in which case returns cell of cells
%
%   degenerate case: if str is empty, or non-string, returns single cell of ''
%
%   See also JOIN.
%       
% JRI 3/13/07

if iscell(str)
    for i = 1:length(str)
        pieces{i} = split(str{i},delimiter);
    end
    return
end

%degenerate case
if isempty(str)
 pieces = {''};
 return
end

require(ischar(str)&ischar(delimiter),'Inputs must be strings')

delimiter = sprintf(delimiter); %expand escapes such as \t & \n

idelim = strfind(str,delimiter);
ends = [idelim-1 length(str)];
starts = [1 idelim+length(delimiter)];

%trim if we end w/ a delimiter
if starts(end) > length(str)
    starts(end) = [];
    ends(end) = [];
end

nPieces = length(starts);
pieces = cell(1,nPieces);

for i = 1:nPieces
   pieces{i} = str(starts(i):ends(i));
end