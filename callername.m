function name = callername
% callername    get name of calling mfile
%
%   when used within a function, returns the name of the function that called it
%      
%   returns '' if called from command line
%
% JRI 2/13/07

stack = dbstack('-completenames');

if length(stack)>2,
    name = stack(3).name;
else
    name = '';
end
