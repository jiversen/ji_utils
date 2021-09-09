function show_progress(count, maxcount, every, display)
% show_progress  Display progress
%
%   show_progress(count, maxcount, [every],[display])
%
%       prints count modulo every (default 10) up until maxcount
%       display true shows percent
%   
%   JRI


if nargin==0,
    eval(['help ' mfilename])
    return
end

if nargin < 3,
    every = 10;
end

if nargin < 4,
   display = false; %true plots percent
end

%if ~rem(count,every) | count == 1,  %print every inc
    if display,
        fprintf('%d%% ',round(100*count/maxcount))
    else
        fprintf('%d ',count)
    end
    drawnow %hack to make responsive to control-c interrupt    
    %else
   % fprintf('.');
%end
if count >= maxcount, fprintf('\n'); end
