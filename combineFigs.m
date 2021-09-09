function combineFigs(figs,rows,cols,orientation)
% combineFigs  Combine a set of figure windows into a single figure
%
%   combineFigs(figs,rows,cols, [orientation])
%
%   note, only works with a single axis in each figure to be combined
%
%   optional params are same as for jisubplot & are passed directly
%   default orientation is 'portrait'
%   prop/value pairs are applied to copied axes
%
% JRI

if nargin==0
    help combineFigs
    return
end

if nargin == 3,
    orientation = 'portrait';
end

%properties to apply to destination axes
axisArgs = {'fontsize',8};

%setup new figure
figure
jisubplot(rows,cols,0,orientation,[.2 .2],axisArgs{:})
finalFig = gcf;

for fig = figs,
   figure(finalFig)
   nextplot
   destinationAxis = gca;
   %grab some positional params of destination, then delete (making it ineligible for future subplotting)
   destPos = get(destinationAxis,'position');
   delete(destinationAxis)
   
   figure(fig)
   sourceAxis = get(fig,'Children');
   %don't copy over adornments (which have tags)
   sa = findobj(gcf,'tag','','type','axes');
   if ~isempty(sa),
     sa = sa(1);
   else
     sa = get(gcf,'children');
     ignore = findobj(gcf,'type','uimenu');
     sa = setdiff(sa,ignore);
   end
   
   newAx = copyobj(sa,finalFig);
   axes(newAx)
   set(newAx,'position',destPos,axisArgs{:});
   
%    axes(sa)
%    contents = get(sa,'children');
%    limits = axis;
%    h = copyobj(contents,destinationAxis);
%    axes(destinationAxis)
%    axis(limits)
   hold on
end
