function idx = strmatch_mixed(str, strs, varargin)
% strmatch_mixed  Like strmatch, but fixes a shortcoming:
%                   accepts cell array also containing non-string elements
%                   and matches only to the string elements
%
%   this is useful for parameter lists in which some elements are numeric
%
%   idx = strmatch_mixed(str, strs)
%   idx = strmatch_mixed(str, strs, options) 
%       options:    'exact' exact match (as for strmatch)
%                   'lower' case-insensitive match
%
% JRI 10/29/01

% Free for all uses, but please retain the following:
%   Original Author: John Iversen
%   john_iversen@post.harvard.edu

exact = ~isempty(strmatch('exact', varargin));
do_lower = ~isempty(strmatch('lower', varargin));

%get string elements in cell (must be a better way than this)
str_elems = [];
if ~iscell(strs),
    strs = cellstr(strs);
end
for c = 1:length(strs),
    if isstr(strs{c}),
        str_elems = [str_elems c];
    end
end
strs = strs(str_elems);

if do_lower,
    str = lower(str);
    strs = lower(strs);
end

if ~exact
    idx_str = strmatch(str, strs);
else
    idx_str = strmatch(str, strs, 'exact');    
end

idx = str_elems(idx_str);