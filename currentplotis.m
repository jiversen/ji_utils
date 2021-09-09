function bool = currentplotis(test)
% currentplotis  Test if current plot pane is at a special location (e.g. row end, etc)
%
%   this is used in conjunction with JISUBPLOT to control, e.g. display of
%       axis labels based on position of current subplot axis.
%
%   bool = currentplotis(test)
%
%   INPUT
%       test    'atRowBeginning', 'atRowEnd', 'atColumnBeginning', 'atColumnEnd'
%                   'atPaneZero' (case insensitive)
%
%   OUTPUT 
%       bool    true if current axis satisfies test
%
%   Examples:
%
%         %show x/y labels only when necessary
%         if currentplotis('atrowbeginning')
%             ylabel('Y')
%         end
%         if currentplotis('atcolumnend')
%             xlabel('X')
%         end
%
%         %draw colorbar only at end of row of plots
%         if currentplotis('atRowEnd'),
%             jicolorbar('vshort')
%         end
%
%
%   NB if plot was not setup using jisubplot, returns true in all cases
%
%   See also JISUBPLOT, NEXTPLOT, JISUBPLOTDEMO
%
%   2005 JRI (iversen@nsi.edu)

% Free for all uses, but please retain the following:
%   Original Author: John Rehner Iversen
%   john_iversen@post.harvard.edu

%access parameters from userdata to calculate next pane
try
	UD = getappdata(gcf,'JRI_jisubplotData');
catch
	UD = get(gcf,'userdata');
end
if isempty(UD),
   %error('Fig must be initialized by jisubplot!') 
   bool = 1;
   return
end

row = UD.pane(1);
col = UD.pane(2);

switch lower(test),
    
    case 'atrowbeginning',
        bool = (col == 1);
        
    case 'atrowend',
        bool = (col == UD.columns);
        
    case 'atcolumnbeginning',
        bool = (row == 1);
        
    case 'atcolumnend',
        bool = (row == UD.rows);
        
  case 'atpanezero',
    bool = ~(row+col);
        
    otherwise
        error('incorrect test name')
end