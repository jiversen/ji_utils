function hout=jisuptitle(str,size)
% JISUPTITLE Puts a title above all subplots. Does not resize axes (unlike suptitle).
%
% hout=jisuptitle(str,[size])
%
%	jisuptitle('text') adds text to the top of the figure
%	above all subplots (a "super title"). 
%	Size specifies points added to normal plot fontsize. (default
%	is 4.)
%
% JRI 10/99 modified--doesn't scale axes
%		takes parameters from globals
%		called with no args, uses most recent suptitle string
%     caled w/ args, sets globals
%
% returns handle to text if asked

% Drea Thomas 6/15/95 drea@mathworks.com



global G %SETS: G.plot.layout.jisuptitlestr, G.plot.layout.jisuptitlesize

if isempty(G),
    hasglobal = 0;
else
    hasglobal = 1;
end

% Parameters used to position the supertitle.
if hasglobal,
    % Amount of the figure window devoted to subplots
    plotregion = G.plot.layout.yplotregion;
    % Y position of title in normalized coordinates
    titleypos  = G.plot.layout.suptitleypos;
    titlexpos = mean(G.plot.layout.xplotregion);
else
    plotregion = [.04 .95];
    titleypos = 1;
    titlexpos = .5;
end

% Fontsize for supertitle
if nargin < 2,
	size = 4;
end

% No arguments, get title string from global (stored by last jisuptitle call)
% if string passed in, set global to it

if hasglobal,
    if nargin==0,
        str  = G.plot.layout.jisuptitlestr;
        size = G.plot.layout.jisuptitlesize;
    else
        G.plot.layout.jisuptitlestr  = str;
        G.plot.layout.jisuptitlesize = size;   
    end
end
    
if isempty(str), return;end
   
fs = get(gcf,'defaultaxesfontsize')+size;

   % Fudge factor to adjust y spacing between subplots
fudge=0; %make no adjustments to axes!

currentaxis=~isempty(findobj(gcf,'type','axes'));

if currentaxis,
   haold = gca;
   %test if this handle is suptitle, if so, don't worry about deleting, since do so later
   if (strcmp(get(haold,'Tag'),'suptitle')),
   	haold=[];   
   end
else
   haold=[];
end

figunits = get(gcf,'units');

% Get the (approximate) difference between full height (plot + title
% + xlabel) and bounding rectangle.

	if (~strcmp(figunits,'pixels')),
		set(gcf,'units','pixels');
		pos = get(gcf,'position');
		set(gcf,'units',figunits);
	else,
		pos = get(gcf,'position');
	end
	ff = (fs-4)*1.27*5/pos(4)*fudge;
        % The 5 here reflects about 3 characters of height below
        % an axis and 2 above. 1.27 is pixels per point.
	
h = findobj(gcf,'Type','axes');  % Change suggested by Stacy J. Hills


max_y=0;
min_y=1;

oldtitle = findobj(gcf, 'Type', 'axes', 'Tag', 'suptitle');

np = get(gcf,'nextplot');
set(gcf,'nextplot','add');
if (~isempty(oldtitle)),
	delete(oldtitle);
end
ha=axes('pos',[0 1 1 1],'visible','off','Tag','suptitle');
%massage string
str = protect_underscore(str);

ht=text(titlexpos,titleypos-1,str);
set(ht,'horizontalalignment','center','fontsize',fs,'verticalalignment','top')
%,...'fontweight','bold'); 

set(gcf,'nextplot',np);

%% this is a nice idea, but if last axis has a legend, it causes
% it to be hid
%if ~isempty(haold)
%   axes(haold);
%end

if nargout,
	hout=ht;
end