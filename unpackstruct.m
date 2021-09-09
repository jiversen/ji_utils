function unpackstruct(s,varnames)
% unpackstruct unpacks a struct, placing new vars with same name as fields in caller's space
%
%   unpackstruct(s)
%
%       s       structure
%       names   optional, cell array of fieldnames to unpack (if not specified, unpacks all)
%
%   JRI 3/13/06

if ~isstruct(s),
    error('argument must be a structure')
end

% no names specified, use all fields
if nargin < 2,
    varnames = fieldnames(s);
end

for i = 1:length(varnames),
    %check to make sure there's a field (only in case caller supplied a list of fields)
    if nargin>=2 && ~isfield(s,varnames{i}),
        warning(['No field named ' varnames{i}])
        continue
    end
    assignin('caller', varnames{i}, s.(varnames{i}) )
end
