function blockclose(fig)
% blockclose  prevent a figure from being closed by the 'close' command
%
%   blockclose(fig)
%
%     prevent fig from being closed using the close command
%
%     useful if you want to do 'close all' but hot close some figures (e.g. a gui)
%
%     must use close box to actually close
%
% JRI 2/24/21 (jiversen@ucsd.edu) generalized from starteeglab

%make widow it unclosable (good for close all)
set(fig,'CloseRequestFcn',@closeit);

%block closes when the 'close' command is used, but allow clicks to
%close button (solution suggested by Jan Simon)

function closeit(src, event)
stack = dbstack;
caller = {stack.name};
calledByClose = any(strcmp(caller,'close'));
if ~calledByClose
    delete(src)
end
