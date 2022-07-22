function pieces = jisplit(str,delimiter)
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
      tmp = split(str{i},delimiter);
      pieces{i} = tmp(:)'; %make a row
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
    
