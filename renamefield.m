function s = renamefield(s, from, to )
% renamefield rename field within a struct
% 
%   s = renamefield(s, from, to )
%
% fails silently if there is no s.from
%
%   from & to may be cell of strings of same length: s.to(i) = s.from(i)
%
% JRI 7/17/13

if nargin==0,
  eval(['help ' mfilename])
  return
end

if ~iscell(from), from = {from}; to = {to}; end
require(length(from)==length(to),'from and to must be of same length')

fn = fieldnames(s);

for iF = 1:length(from),
  %try,
  [s.(to{iF})] = deal(s.(from{iF}));
  s = rmfield(s, from{iF});
  
  fn{strmatch(from{iF},fn,'exact')} = to{iF};
  %catch
    %warning('%s not be a field; skipping',from{iF})
  %end
end

s = orderfields(s,fn);

