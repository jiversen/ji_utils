function jiwritetable(fname, data, colLabels, format)
% jiwritetable  write tabular data to file
%
%   jiwritetable(fname, data, [colLabels, format])
%
%  INPUTS
%       fname       filename (will be tab delimited fname.txt, unless file passed is .csv)
%       data        1 or 2d numeric or cell matrix (each element a scalar or string)
%                   1d cell vector of cells, each containing a column's data
%                   or, struct--fieldnames = colLabels, handles nested srructs
%       colLabels   Column names
%       format      'csv' override tab delimited format and use csv (fname.csv)
%
% JRI
%
%   JRI 11/19/12 modified from openInJMP

% TODO: modify to accept struct OK
% TODO: infer format from fname OK
% TODO: adjust calling format to put fname first OK
% TODO: allow nesting: if a field contans a struct, generate variables with that fieldname prepended OK

if ~nargin,
  eval(['help ' mfilename])
  return
end

if nargin < 4,
  format = 'tab';
end

if nargin < 3,
  colLabels = {};
end

[~,~,ext] = fileparts(fname);
if strcmp(ext,'.csv'), format = 'csv'; end

switch format,
  case 'tab',
    delimiter = '\t';
    doCsv = false;
    fileext = 'txt';
  case 'csv',
    delimiter = ','; 
    doCsv = true;
    fileext = 'csv';
  otherwise
    error('unrecognized format')
end

[path,name,ext] = fileparts(fname);
if isempty(ext),
  ext = ['.' fileext];
end
fname = fullfile(path,[name ext]);

% convert struct
if isstruct(data),
  data = flattenStruct(data);
  if isempty(colLabels),
    colLabels = fieldnames(data);
  end
  data = permute(struct2cell(data), [3 1 2]);
end

[nRow, nCol] = size(data);

%empty column names: only write data
if isempty(colLabels)
  startRow = 1;
else
  assert(length(colLabels)==nCol,...
    'there must same number of labels as columns in data')
  startRow = 0; %means we'll write column labels before data
end

%classify what type of data we've been passed & pick indexing mode
if isnumeric(data),
  elementCmd = 'data(iR,iC)'; %how to access an element
elseif iscell(data),
  if nRow==1, %data is a cell array of columns
    for iC = 1:nCol,
      [r,c] = size(data{iC});
      if (c>1 && r==1),
        data{iC} = [data{iC}]';
      end      
      [r,c] = size(data{iC});
      assert(r>1,['cell array contents must be column vectors (col # ' num2str(iC)]);
      nRow = r;
    end
    elementCmd = 'data{iC}(iR)';
  else %data is a cell matrix
    elementCmd = 'data{iR,iC}';
  end
else
  error('unsupported data type')
end

%write data to a file, tab or comma delimited, with column labels in first line

%fname = [fname '.txt'];
fid = fopen(fname,'w');

if fid<0,
  error('couldn''t open file')
end

for iR = startRow:nRow,
  for iC = 1:nCol,
    if iR==0,
      label = colLabels{iC};
      if doCsv,
       label = enquote(label);
      end
      fprintf(fid,'%s',label);
    else
      element = eval(elementCmd);
      %unpack a cell, ensure it's scalar
      if iscell(element),
        if numel(element)>1, error('each element must be a scalar'),end
        element = element{1};
      end
      
      %write depending on type
      if isnumeric(element) || islogical(element),
        if numel(element)>1, error('each element must be a scalar'),end
        if ~isnan(element), %nan = missing data; don't write any value
          fprintf(fid,'%g',element);
        end
      elseif ischar(element),
        if doCsv,
          element = enquote(element);
        end
        fprintf(fid,'%s',element);
      else
        error('unsupported element type')
      end
    end
    %terminate a row, or delimit values
    if iC < nCol,
      fprintf(fid, delimiter);
    else
      fprintf(fid,'\n');
    end
  end
end
fclose(fid);

function str = enquote(str)
% enquote  properly quote & escape csv string elements

if ~ischar(str) || isempty(str), return, end

doEnquote = false;

if any(str=='"'),
  doEnquote = true;
  str = strrep(str,'"','""');
end

if any(str==','),
  doEnquote = true;
end

if any(str==sprintf('\n')) || any(str==sprintf('\r')),
  doEnquote = true;
end

if doEnquote,
  str = ['"' str '"'];
end

function Sf = flattenStruct(S,prefix)
% flattenStruct flatten structs within struct
%
% e.g. S.scalar
%      S.struct.scalar
%      S.struct.scalar2
%
% becomes
%      S.scalar
%      S.struct_scalar
%      S.struct_scalar2
%
% also handles 1-d struct arrays
% JRI

if nargin<2,
  prefix = '';
end

if ~isempty(prefix),
  prefix = [prefix '_'];
end

Sf = struct;

nElem = length(S); 

for iE = 1:nElem,
  
  for fn = fieldnames(S)',

    if ~isstruct(S(iE).(fn{1})),
      Sf(iE).([prefix fn{1}]) = S(iE).(fn{1});
    else
      tmp = flattenStruct(S(iE).(fn{1}),[prefix fn{1}]);
      %uglynes to enable us to cat like this
      % https://www.mathworks.com/matlabcentral/newsreader/view_thread/239866
      newfields = setdiff(fieldnames(tmp), fieldnames(Sf(iE)));
      %reorder according to original order
      [~,sidx] = match_str(fieldnames(tmp),newfields);
      newfields = newfields(sidx);
      %add placeholders
      for nfn = newfields(:)',
        Sf(iE).(nfn{1}) = [];
      end
      %finally, copy
      Sf(iE) = copyfields(tmp,Sf(iE));
    end

  end
 
end 
