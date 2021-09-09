function varargout = getparam(param, paramlist, n, varargin)
% getparam  Get values for a parameter in a parameter list
%
%   processes standard 'param1', value1, 'param2', value2 lists, 
%       as well as those having an arbitrary number of values following
%       a parameter: 'param1', value1a, value1b, value1c, 'param2',...
%
%   [a1, ... an] = getparam(param, paramlist, [n], [defaults])
%
%   val = getparam(param,[default]) %simplified common use case
%
%   INPUTS
%       param      parameter name
%       paramlist  cell array, an element for each arg (typically use varargin)
%       n          optional, number of values to capture following this param. Defaults to 1.
%       defaults   optional, n default value(s), comma separated, returned if param not found
%                       if defaults are unspecified, and param is not defined,
%                       getparam returns empty values.
%
%   OUTPUTS
%       a1, ... an  return values for param, must be n of them
%                  
%   See also ISPARAM, STRMATCH_MIXED.
%
%
% Free for all uses, but please retain the following:
%   Original Author: John Iversen, 2002
%   john_iversen@post.harvard.edu

%   Depends on these other JRI m-files: isparam.m, strmatch_mixed.m

%
%   jri 10/18/02
%

if nargin < 3,
    n = 1;
end

if nargout && nargout ~= n,
    error('JRI:getparam:wrongNumberOfOutputs', ...
        'Number of outputs must match number of values (%d)',n)
end

%handle simple use case
if nargin==1,
  paramlist = evalin('caller','varargin');
end
%not entirely correct--fails for defaults that are themselves cell arrays
if nargin==2 && ~iscell(paramlist),
  varargin = {paramlist};
  paramlist = evalin('caller','varargin');
end

%try to find parameter name in the parameter list
[gotit, idx] = isparam(param,paramlist);

if gotit,
    %if specified more than once, warn, take the last instance
    if length(idx) > 1,
        idx = idx(end);
        warning('JRI:getparam:paramDefinedMultipleTimesWarning', ...
            'parameter ''%s'' was defined multiple times. Using values from final definition.',param)
    end
    %ensure there are the required number of values for this parameter
    if length(paramlist) < idx+n,
        error('JRI:getparam:notEnoughValuesForParam', ...
            'Not enough values for parameter ''%s'' (needs %d)',param,n);
    end
    varargout = paramlist(idx+1:idx+n);
else
    %use defaults if any
    if length(varargin) == n,
        varargout = varargin;
    else
        if ~isempty(varargin),
            warning('JRI:getparam:incorrectNumberOfDefaultsWarning', ...
                'Defaults specified, but there is incorrect number, so not using them.')
        end
        %no defaults, return empty args
        varargout = cell(1,n);    
    end
end
