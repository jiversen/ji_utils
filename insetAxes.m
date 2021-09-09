function hout = insetAxes(varargin)
% insetAxes  Flexible creation of inset plots. Can add an inset version of one axis onto another.
%
%   insetAxes   Create an empty inset axis within gca with default parameters
%                   (placed in upper left corner, 1/3 the size of current axis).
%
%   insetAxes(param,value,...)  Create an inset plot with properties according to
%                                parameter / value pairs.
%
%   insetAxes('source',axh,...) Create inset, and copy contents of source axis
%                                axh into it.
%
%  INPUT PARAMETERS
%   source      axis containing existing plot to inset. If [], or unspecified,
%                   create a new axis to draw into.
%   location    optional, corner to place inset into, ('ul','ur','ll' or 'lr'). Default 'ul'
%   size        optional, ratio of inset axis size to destination axis. Default 1/3.
%   layer       optional, 'over' (default) or 'under' controls whether inset
%                   is placed over or behind dest axis.
%   delete      delete any existing inset axes first
%
%  OUTPUTS
%   newax       optional, handle to new inset axis
%
%   Notes:
%       Depends on JRI functions scaleAxis.m, getParam
%       Side Effect:  If layer is 'under', destaxis is modified: color set to
%           'none' so inset can show through
%
%   EXAMPLES
%
%       %1) simple usage
%       figure
%       line
%       insetAxes %create new axis within first
%       line; title('inset plot')
%
%       %2) combine two existing plots, placing first as an inset within second
%
%       %create the source of our inset
%       figure
%       pcolor(peaks)
%       sourceAxis = gca;
%
%       create the figure that accepts the inset
%       figure
%       logo %this might not work--seems not to create an axis?
%       bigAxis %this fixes it, but need something better
%       insetAxes('source',sourceAxis)
%       axes(destAxis)
%
%
%   See also scaleAxis.
%
%
% Free for all uses, but please retain the following:
%   Original Author: John Iversen, 2006
%   john_iversen@post.harvard.edu

% JRI 02/16/2006

%defaults
srcaxis = getparam('source',varargin,1);
location = getparam('location',varargin,1,'ul');
size = getparam('size',varargin,1,1/3);
layer = getparam('layer',varargin,1,'over');
doDelete = isparam('delete',varargin);

if doDelete,
    delete( findobj(gcf,'tag','jri_insetAxes') );
end

if ~strmatch(lower(location),{'ul','ur','ll','lr'},'exact'),
    error('JRI:insetAxes:incorrectLocation', ...
        'Incorrect value for location. Must be ''ul'',''uc'',''ur'',''ll'', ''lc'' or ''lr''.')
end

%destination axis is the current axis
destfig = gcf;
destaxis = gca;

%get destination axis position
destpos = get(destaxis,'position');
[destminor, idx] = min(destpos(3:4)); %smallest dimension & identity
%find scale factor by which to reduce new axis
destsize = destminor * size; %size relative to original axis
    
if ~isempty(srcaxis),

    newax = copyobj(srcaxis, destfig);
        
    srcpos = get(srcaxis,'position');
    srcminor = srcpos(2+idx);
    scale = destsize / srcminor;
    axes(newax);
    scaleAxis(scale,scale);
else
    srcaxis = axes;
    srcpos = get(srcaxis,'position');
    srcminor = srcpos(2+idx);
    scale = destsize / srcminor;
    
    newax = srcaxis;
    axes(newax);
    scaleAxis(scale,scale);
end

newpos = get(newax,'position');
xo=newpos(1);yo=newpos(2);
w=newpos(3);h=newpos(4);

%inset versions of axis bounds
inset = 0.05;
destleft    = destpos(1) + 2*inset*destpos(3);
destright   = destpos(1) + (1-inset)*destpos(3);
destbot     = destpos(2) + 2*inset*destpos(4);
desttop     = destpos(2) + (1-inset)*destpos(4);

 switch(location(1)),
     case 'u',
         yo = desttop - h;
     case 'l',
         yo = destbot;
 end
 
 switch(location(2)),
     case 'l',
         xo = destleft;
     case 'r',
         xo = destright - w;
     case 'c',
         span = destright - destleft;
         xo = destright - span/2 - w/2;
 end

set(newax,'position',[xo yo w h])
set(newax,'tag','jri_insetAxes')

%set destaxis so we can see thru to inset
if strcmp(layer,'under')
    set(destaxis,'color','none')
end

%axes(currentax)
%figure(currentfig)

if nargout,
    hout = newax;
end

