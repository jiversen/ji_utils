function require(condition, description)
% require   JRI style assert handler
%
%   require(condition, description)
%
%       A plain english way to specify code expectations.
%           Ensure condition is met. If not, raise error, printing description
%
% JRI 1/9/07

if nargin==0,
    help require
    return
end

if nargin < 2,
    description = '';
end

if ~(condition),
    %dbstop if error
    error([callername ':requirementNotMet'],description)
end
