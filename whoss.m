function whoss(var, lvl)
% whoss show memory usage within a struct
%
%   whoss varname
%
%   prints size of fields/subfields greater than 1MB
%
% JRI date?

%   whos(varname, lvl) %internal, recursive use
%

if nargin==0,
    eval(['help ' mfilename])
    return
end

% if ~isstruct(var),
%   disp('variable is not a structure.')
%   return
% end

if nargin < 2,
    lvl = 0;
end
ind = repmat('*', 1, lvl);

if ~isstruct(evalin('caller',var)),
    whos(var)
end

fn = fieldnames(evalin('caller',var));

for i = 1:length(fn),
   tmp = evalin('caller',[var '.' fn{i} ]);
   if isstruct(tmp), whoss('tmp', lvl+1); end
   tmpw = whos('tmp');
   b=round(tmpw.bytes/1024/1024);
   if b<2, continue, end
   fprintf('%s%10s: %d Mb\n',ind, fn{i}, b)
end

