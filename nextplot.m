function nextfig=nextplot(varargin)
% NEXTPLOT Advance to next plotting pane in figure set up with JISUBPLOT.
%
%   Uses:
%   This is handy for easily creating complex arrays of plots.
%	Never again need to keep track of subplot pane indexes. 
%
%   Features:
%   After setting up a subplot grid with a call to JISUBPLOT, NEXTPLOT 
%   makes it easy to iterate through the axes panes without having to keep track
%   of any indexes as you do with subplot. Options allow for much flexibility: 
%   iterate axes by row or by column, starting a new row or new column of plots,
%   creating axes of different sizes, etc...
%	A nice aspect is that NEXTPLOT will create new figures automatically once all
%	axes on the current one have been used...
%
%   Usage:
%
%   nextplot
%		advance along row to next plot pane in grid set up with jisubplot
%           this is the same as incrementing the pane index in subplot
%	
%   nextplot(options)
%       options include 
%
%       to specify location of next axis	
%       'byrow'			advance along row (default)
%       'bycol' 		to advance down columns rather than default rowwise
%       'newrow', 'newcol' 	start a new row or column
%       'delta'			followed by a 2 element vector [deltarow, deltacol]
%           			moves to a pane relative to current one
%           			(e.g. nextplot('bycol') = nextplot([1 0]),
%               		nextplot = nextplot([0 1]), and so on)
%
%       'skip' 			to skip a pane
%
%       'size'          followed by a 2 element vector [width height],
%                       move as above and create an axis width x height grid 
%                           units in size (default is [1 1])
%
%   nextfig = nextplot...
%       if we move to a new page, return new figure number, else 0
%
%   Examples: 
%       figure
%       jisubplot(4,5,0,'portrait',[],'fontsize',7)
%       nextplot
%       nextplot('bycol')
%       nextplot('newcol')
%       nextplot('bycol')
%       nextplot('newrow','size',[2 2])
%       nextplot('newcol','size',[1 1])
%       nextplot('delta',[1 1])
%
%       see jisubplotdemo.m for many (more useful) examples
%
%   See also JISUBPLOT, CURRENTPLOTIS, JISUBPLOTDEMO.
%
%   John Iversen iversen@nsi.edu
%

% JRI 10/12/99
% JRI 8/17/00 rewrote to call jisubplot, since most of code is was same
% JRI 9/15 updated for new MATLAB graphics

% depends on: jisubplot.m, isparam.m, getparam.m, strmatch_mixed.m

% Free for all uses, but please retain the following:
%   Original Author: John Iversen
%   john_iversen@post.harvard.edu

delta = [];
panesize = [];

    plotfig = gcf; %note, this will create a figure if not one already!
    %convert figure object to old-style figure number
    if ~isnumeric(plotfig),
      plotfig = plotfig.Number;
    end
    
    %test for string options
    skip    = isparam('skip',varargin);
    bycol   = isparam('bycol',varargin);
    newrow  = isparam('newrow',varargin);
    newcol  = isparam('newcol',varargin);
    
    %test for size & delta params
    delta       = getparam('delta',varargin);
    panesize    = getparam('size',varargin,1,[1 1]);
    
    %enforce sense
    if ~isempty(delta) && (bycol || newrow || newcol),
       error('only action consistent w/ delta is ''skip''') 
    end

%access parameters to calculate next pane
try
	UD = getappdata(plotfig,'JRI_jisubplotData');
catch
	UD = get(plotfig,'userdata');
end
if isempty(UD),
   warning('Fig has not been initialized by jisubplot! initializing.') 
   jisubplot
   plotfig = gcf;
   try
     UD = getappdata(plotfig,'JRI_jisubplotData');
   catch
     UD = get(plotfig,'userdata');
   end
   if isempty(UD),
     error('Could not initialize subplot')
   end
end

%advance to next pane
rows = UD.rows;
columns = UD.columns;
pane = UD.pane;
row = pane(1);
col = pane(2);
w = pane(3);
h = pane(4);
isFirst = (row == 0); %if this is the first plot on this figure

%advance row, col of next plot
if isFirst,
    row = 1;
    col = 1;
else
    if newcol, %advance to the top of next column
        row = 1;
        col = col + w;
    elseif newrow, %advance to start of next row
        row = row + h;
        col = 1;
    elseif bycol, %advance by column
        row = row + h;
        %if we've advanced past the end of one column, start the next
        if row > rows,
            row = 1;
            col = col + w;
        end
    elseif ~isempty(delta), %advance by arbitrary amount
        row = row + delta(1);
        col = col + delta(2);
        % a little funky: we want movement past edge by either row or col to wrap spirally as usual,
        %   but want changes in both to wrap torroidaly, onto a new page
        %past edge of array, enforce spiral edge conditions
        if row > rows && col <=columns,
            col = col + w * floor(row/rows);
            row = mod(row+(rows-1),rows)+1;
        elseif col > columns && row <=rows,
            row = row + h * floor(col/columns);
            col = mod(col+(columns-1),columns)+1;
        elseif row>rows && col>columns,
            col = mod(col,columns);
        end
    else %default: advance by row
        col = col + w;
        if col > columns,
            col = 1;
            row = row + h;
        end
    end
end
pane(1) = row;
pane(2) = col;
if ~isempty(panesize),
    pane(3:4) = panesize;
end

newax=jisubplot(rows,columns,pane); %let jisubplot do the work of making the axis
%it will create a new figure if necessary

if skip, %skip this axis
   delete(newax)
end

%check if we've advanced to a new figure
isNewFig = (gcf ~= plotfig);
if isNewFig,
    plotfig = gcf;
end

if nargout,  
   if isNewFig,  %test if a new figure was created
      nextfig=gcf;
   else
      nextfig=0;
   end
end

%ugly fix for matlab bug (as of R14SP1) where the previous fig somtimes comes in
% front for no discernable reason
%pause(0.2)
%figure(plotfig)

