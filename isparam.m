function [flag, idxout] = isparam(param, paramlist)
% isparam  Check parameter list to see if given parameter was specified
%
%   flag = isparam(param, paramlist)
%
%       returns true if param is found in paramlist (a cell array), false otherwise
%
%   [flag, idxout] = isparam(param, paramlist)
%
%       same, but also returns index in paramlist where param was found
%
%   flag = isparam(param) uses varargin of caller implicitly (new 10/11)
%
%   See also GETPARAM, STRMATCH_MIXED.
%
%
%   jri 10/18/02
%

% Free for all uses, but please retain the following:
%   Original Author: John Iversen
%   john_iversen@post.harvard.edu

if nargin==1,
  paramlist = evalin('caller','varargin');
end

idx = strmatch_mixed(param, paramlist, 'exact', 'lower');
flag = ~isempty(idx);

if nargout == 2,
    idxout = idx;
end