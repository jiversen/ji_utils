function orthoMontage(sourceFig)
% orthoMontage  make an orthogonal montage of a 3-d figure
%
%   orthoMontage(fig)
%
%   note, only works with a single axis in each figure to be combined
%
%   optional params are same as for jisubplot & are passed directly
%   default orientation is 'portrait'
%   prop/value pairs are applied to copied axes
%
% JRI

if nargin==0,
  eval(['help ' mfilename])
  return
end

orientation = 'portrait';

%properties to apply to destination axes
axisArgs = {'fontsize',10};

%view args
viewArgs = {[90 0], [0 0], [0 90], [14.5 56]}; %optimized for NDB's dipplot output

%don't copy over adornments (which have tags)
sa = findobj(sourceFig,'type','axes');
sa = intersect(sa, findobj(sourceFig,'tag','','-or','tag','JPLOT3','-or','tag','topo'));
sa = sa(1); %only use the first axis found
%get its title
tit = get(get(sa,'title'),'string');

if isempty(sa),
  disp('no axis')
  return
end

%setup new figure
figure
jisubplot(2,2,0,orientation,[.1 .1],axisArgs{:})
finalFig = gcf;

for i = 1:4,
  nextplot
  destinationAxis = gca;
  %grab some positional params of destination, then delete (making it ineligible for future subplotting)
  destPos = get(destinationAxis,'position');
  delete(destinationAxis)
  
  newAx = copyobj(sa,finalFig);
  set(newAx,'position',destPos,axisArgs{:});
  axes(newAx)
  view(viewArgs{i})
  set(get(newAx,'title'),'string','')
  
  hold on
end
zoom(.8); %shrink 3d view

rotate3d on

if ~isempty(tit),
  jisuptitle(tit)
end
