function [ret1, ret2, ret3]=timestamp(prefix)
% TIMESTAMP  Timestamp the current figure.
%
%  [stamp, file_stamp]=timestamp([str])
%  [stamp, file_stamp_date, file_stmp_time] ...
%
%	automatically add the date and time to the current figure
%
%   e.g.  jri 7-Nov-1997 03:14:22 (in lower right corner)
%
%  if called w/ output argument, returns date & time string, 
%   and doesn't touch the figure. 2nd output arg is timestamp str suitable to add to a filename
%
%  if called w/ input argument=string, prepends that string to timestamp (and sets
%    global G.plot.print.timestampprefix to EMPTY)
%   (useful for adding figure number, for example)
%
%   new:will get the name of the function calling us and include in prefix--
%       helps when looking back at plots to know which function produced it.
%
%
%	global 'G.plot.print.timestamp' controls whether it's displayed
%   The string in G.plot.print.timestampprefix is prepended to the stamp.
%
% 1997, written by JRI (iversen@nsi.edu), adapted from suptitle.m

% 2007, fixed bug in which figure is created when outputs requested

global G

user=username; %user name will appear in timestamp

%timestamp text: default is prefix user date and time
rightnow = fix(clock);
time = sprintf('%2d:%2d:%2d',rightnow(4),rightnow(5),rightnow(6));
time = strrep(time,' ','0');

dateStr = datestr(now,'yyyy.mm.dd');

%asked for return argument, so return current date & time and don't timestamp the figure
if nargout==1,
    ret1=[date ' ' time];
    return
elseif nargout==2,
    ret1=[date ' ' time];
    ret2=[dateStr '_' strrep(time,':','.')];
    return
elseif nargout==3,
    ret1=[date ' ' time];
    ret2=dateStr;
    ret3=strrep(time,':','.');
    return
end

% From here, no nargout, so will operate on a figure, creating one if
% necessary

%find existing timestamp (if any figures exist)
if isempty(get(0,'children')),
    currentfig = [];
    oldstamp = [];
else
    currentfig = gcf;
    oldstamp = findobj(currentfig,'Type','axes','tag','JRI_TIMESTAMP');
end

%special case, used from printmulti to cause it to not replace an
%   existing timestamp. If no timestamp, continue as normal
if (nargin >= 1) && strcmp(prefix,'jri_printmulti_noclobber')
    if ~isempty(oldstamp),
        return
    else
        prefix = '';
    end
end

%get caller's name
[stack,idx]=dbstack;
if (length(stack) == 1),
    mfilename = '';
else
    mfilename = [stack(idx+1).name];
end

% no prefix passed in; try to get it from figure or global
if ~nargin,
  prefix = [];
  try
    prefix = getappdata(currentfig,'JRI_timestampTag');
  catch
    prefix = [];
  end
  if isempty(prefix) && exist('G','var') && ~isempty(G),
    prefix = [G.plot.print.timestampprefix ' ' mfilename];
  end
end
    
%default position: lower right of figure (and lr of text) (normalized units)
stampx=.95;
stampy=0.03;
%stamp font size
stampsize=9;

% handle the prefix
% if ~nargin, 
%    prefix = [G.plot.print.timestampprefix ' ' mfilename];
% else
%     prefix = [prefix ' - ' mfilename];
%    G.plot.print.timestampprefix = '';
% end
prefix=['\bf' prefix '\rm   '];

stamp = [prefix user ' '  date ' ' time];
if exist('protect_underscore'),
    stamp = protect_underscore(stamp);
end

%timestamp is disabled, say so
if exist('G','var') && ~isempty(G) && ~(G.plot.print.timestamp),
   fprintf(1,'\ntimestamp disabled\n');
   return
end

%get list of axes (not including timestamp)
axh = findobj(currentfig,'type','axes');
axh = setdiff(axh,oldstamp);
%save the current axis (if there is one)
if ~isempty(axh),
   currentaxis=gca;
end

%%Add timestamp to figure

%switch nextplot and units (saving old values)
np=get(currentfig,'nextplot');
set(currentfig,'nextplot','add');
units=get(currentfig,'units');
set(currentfig,'units', 'normalized')

%delete oldstamp if it exists
if ~isempty(oldstamp),
	delete(oldstamp);
end

%create timestamp: axis, text
stampa=axes('pos',[0 0 1 1],'visible','off','Tag','JRI_TIMESTAMP');
stampt=text(stampx,stampy,stamp,'HorizontalAlignment','right',...
   'FontSize',stampsize);

%restore nextplot, units
set(currentfig,'nextplot',np);
set(currentfig,'units',units);

%reset gca to axis that was current when we started
if exist('currentaxis') && ishandle(currentaxis),
   axes(currentaxis);
end
