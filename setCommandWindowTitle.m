function setCommandWindowTitle(str)
% setCommandWindowTitle  customize command window title with hostname and optional string
%
%   setCommandWindowTitle
%       title: ( hostname )  MATLAB R2099z
%
%   setCommandWindowTitle(str)
%       title: ( hostname ) -- str -- MATLAB R2099z
%
%
% JRI 6/29/13 jiversen@ucsd.edu

if isunix && ~isTextOnlyMatlabSession,
    [~,hn]=unix('hostname;');
    hn = deblank(hn);
    ver = regexp(version,'\(([^)]+)\)','tokens');
    originalCommandWindowTitle = sprintf('MATLAB %s',ver{1}{1});

    if ~nargin,
        newTitle = sprintf('( %s )   %s', hn, originalCommandWindowTitle);
    else
        newTitle = sprintf('( %s )  -- %s --  %s', hn, str, originalCommandWindowTitle);
    end
    
    % jri private
    if isParallel,
      global JRI_N_THREADS JRI_THIS_THREAD JRI_START_OFFSET
      if ~isempty(JRI_START_OFFSET) && JRI_START_OFFSET~=0,
        offStr  = sprintf(' (+%d)',JRI_START_OFFSET);
      else
        offStr = '';
      end
      parStr = sprintf('  << Par %d of %d%s >>', JRI_THIS_THREAD, JRI_N_THREADS, offStr);
      newTitle = [newTitle parStr];
    end
    
    %setPrompt([hn(1:3) ' >> ']); %put hostname into command prompt
    %better approach: add hostname to command window title (http://stackoverflow.com/questions/1924286)
    jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    jDesktop.getMainFrame.setTitle(newTitle);
end



function bool = isTextOnlyMatlabSession
% isTextOnlyMatlabSession  test if this matlab instance can plot or is text only
%
% JRI 7/26/13

bool = usejava('jvm') && ~usejava('Desktop');

function bool = isParallel
% isParallel    Are we processing in parallel?
%
%   bool = isParallel
%
%       return true if we're processing in parallel
%       use to disable plotting, for example
%
%       uses globals  JRI_N_THREADS  JRI_THIS_THREAD
%
%   JRI 7/11/07


global JRI_N_THREADS

bool = ~isempty(JRI_N_THREADS);