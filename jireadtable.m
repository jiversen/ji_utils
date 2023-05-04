function [data, isnum] = jireadtable(filename, delimiter, cols)
% jireadtable read a simple table from a text file
%
%   data = jireadtable(fname, [delimiter, [cols]])
% 
% first line must contain column labels
% remaining rows will be placed into a struct with column labels as field
% names
% 
% delimiter assumed to be tab (however .csv files assume comma)
% cells with only spaces are treated as empty
%
% cols allows specifying a subset of columns to read as cell array of labels
%
% JRI 8/9/10
% JRI 7/15 add cols

if nargin==0,
  eval(['help ' mfilename])
  return
end

if nargin < 2 || isempty(delimiter),
  delimiter = '\t';
end

%set delimiter for csv to comma
[~,~,ext] = fileparts(filename);
if strcmp(ext,'.csv'),
  delimiter = ',';
end

if nargin < 3,
  cols = {}; %all
end

%% read lines
fid = fopen(filename,'r');
assert(fid>0,'file not found')
lines = textscan(fid,'%s','Delimiter','','whitespace','','bufsize',256000);
fclose(fid);
lines = lines{1};

%% get field names
fnames = split(lines{1},delimiter);
if delimiter == ',',
  dat = fixSplits(fnames);
end

%ensure we have valid fieldnames
fnames = strrep(fnames, '"',''); %remove quotes
fnames = strrep(fnames, '_',' ');  %convert underscores to space so we can trim leading/following
fnames = strtrim(fnames);
fnames = strrep(fnames, ' ', '_'); %convert spaces back
fnames = strrep(fnames, '.', '_'); %dot to underscore
fnames = strrep(fnames, '-', '_'); %dash to underscore
fnames = strrep(fnames, '+', '_'); %plus to underscore
fnames = strrep(fnames, '%', 'pct'); % % to pct

% as final step, catch any remaining invalid characters
for iF = 1:length(fnames),
  if ~isvarname(fnames{iF}),
    fprintf('Fixing invalid fieldname: %s.\n\tYou may want to change it in source file to it is valid.\n',fnames{iF});
    fnames{iF} = genvarname(fnames{iF});
    if strcmp(fnames{iF},'x'),
      fnames{iF} = 'DELETEME';
    end
  end
end

lines(1) = [];
nCol_full = length(fnames); %all fields; we may only read s aubset

%% handle duplicate fieldnames: walk list, if found, add suffix _2, etc
fieldrepeat = [];
for iF = 1:length(fnames),
  idx = strmatch(fnames{iF},fnames(1:iF-1),'exact');
  if idx,
    if ~isfield(fieldrepeat,fnames{iF}),
      fieldrepeat.(fnames{iF}) = 2;
    else
      fieldrepeat.(fnames{iF}) = fieldrepeat.(fnames{iF}) + 1;
    end
    fnames{iF} = sprintf('%s___%d',fnames{iF},fieldrepeat.(fnames{iF}));
  end
end

%% subset the fieldnames
if isempty(cols), %take all fields
  nCol = nCol_full;
  colIdx = 1:nCol_full;
  cols = fnames;
else
  [~,colIdx] = ismember(cols, fnames);
  if any(colIdx==0),
    warning('some specified field names were not found in the data:')
    disp(cols(colIdx==0));
    cols(colIdx==0) = [];
    colIdx(colIdx==0) = [];
  end
   nCol = length(cols);
end

%% determine which columns are numeric (all non-empty values must be numbers)
isnum = true(1,nCol); %all start as numeric, switch to string as soon as non-number occurs
for iR = 1:length(lines),
  testrow = split(lines{iR},delimiter);
  if length(testrow) < nCol_full, %extend any short rows
    testrow{nCol} = [];
  end
  testrow = testrow(colIdx); %subset
  
  for iC = find(isnum), %only bother testing columns that may be numeric
    dat = char(testrow{iC});
    dat = strrep(dat, '"', '');
    dat = deblank(dat); %ignore empty strings
    if isempty(dat), continue; end %empty cell tells us nothing
    isnum(iC) = (isnum(iC) && ~any(isnan(str2double(dat))) && all(isreal(str2double(dat))) ) ...
      || strcmp(lower(dat),'nan'); %number if we can convert it, 
  end
end

%% read lines accordingly
for iR = 1:length(lines),
  dat = split(lines{iR},delimiter);
  if delimiter == ',',
    dat = fixSplits(dat);
  end
  if length(dat) < nCol, %pad out
    dat{nCol} = '';
  end
  dat = dat(colIdx); %subset
  if length(dat) > nCol,
    error('parse error--too many columns of data')
  end
  for iC = 1:nCol,
    thisdat = dat{iC};
    if ~isempty(thisdat),
      thisdat = strrep(thisdat,'""','"');
      thisdat = deblank(thisdat);
    end
    if isempty(thisdat), %convert empty to empty string
      thisdat = '';
    end
    if isnum(iC),
      tmp = str2num(thisdat);
      if isempty(tmp), tmp = nan; end
      data(iR).(cols{iC}) = tmp;
    else
      data(iR).(cols{iC}) = thisdat;
    end
  end %loop on columns
end %loop on rows

%% eliminate fields which had no title, or are uninteresting
toDelete = strmatch('DELETEME',cols);
data = rmfield(data,cols(toDelete));

function strings = fixSplits(strings)
% commas falling within quoted strings will have been mistakenly seen as delimiters
%   combine values between those starthing with a " to those ending with a "
strings(cellfun(@isempty,strings)) = {'@@@'};
firstchar = cellfun(@(x) x(1), strings);
lastchar  = cellfun(@(x) x(end), strings);
quotestart = find(firstchar=='"');
quoteend = find(lastchar=='"');
if length(quotestart) ~= length(quoteend),
  error('parse error to do with quotes')
end
for iQ = length(quoteend):-1:1,
  run = quotestart(iQ):quoteend(iQ);
  tmp = join(strings(run),',');
  strings{run(1)} = tmp(2:end-1);
  strings(run(2:end)) = [];
end
strings(strmatch('@@@',strings)) = {''};
