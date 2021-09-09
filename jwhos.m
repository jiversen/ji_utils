function jwhos(varargin)
%   jwhos    Replacement for builtin whos--prints size of >3d arrays directly
%
%   problem: for n-d arrays (n>3) builtin whos just says size is 4-D, 
%       so I have to keep doing size(var)
%
%   OVERRIDE standard whos
%
%   JRI 10/27/05

%direct builtin calling code stolen from whos, so we can override it

if nargin,
    argStr = [];
    for i = 1:nargin,
        argStr = [argStr '''' varargin{i} ''', '];
    end
    argStr(end-1:end)=[];
    %cmd = ['whos(' argStr ');'];
    cmd = ['builtin(''whos'',' argStr ');'];
else
    cmd = 'builtin(''whos'')';
end
info = evalin('caller',cmd);

if ~isempty(info),
    fprintf('  %-20s%-16s%12s %s\n\n','Name','Size','Bytes','Class');
end
for i = 1:length(info),
    dimstr = sprintf('%dx',info(i).size);
    dimstr(end)=[];
    clstr = info(i).class;
    fprintf('  %-20s%-16s% 12d %s\n',info(i).name,  dimstr, info(i).bytes, clstr);
end
fprintf('\n\n')