function s = packstruct(varargin)
% packstruct packs a set of variables into a structure
%
%   s = packstruct(varnames)
%
%   s = packstrucct(s,varnames)
%
%       varnames    cell array of variables, varnames become field names
%       s           if specified, must be a struct to append fields to
%
%   JRI 3/13/06

if nargin==0
    eval(['help ' mfilename])
    return
end

if isstruct(varargin{1})
  s = varargin{1};
  varnames = varargin{2};
else
  s=[];
  varnames = varargin{1};
end
for i = 1:length(varnames)
    s.(varnames{i}) = evalin('caller',varnames{i});
end
