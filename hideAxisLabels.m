function hideAxisLabels(opt)
% HIDEAXISLABELS  Hide axis text labels (but not ticks)
%
%  hideAxisLabels(['x' | 'y'])
%
%  witn no args, hides both. With 'x' or 'y' specified, hides that one
%
%   JRI 1998

if ~nargin,

   set(gca,'xticklabel','','yticklabel','');

else
   switch opt
   case 'x'
      set(gca,'xticklabel','');
   case 'y'
      set(gca,'yticklabel','');
   otherwise
      error('incorrect option')
   end
end
