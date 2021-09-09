function str = protect_underscore(str)
% protect_underscore  Allow underscores to display correctly w/ latex processor
%
%   note, to get latex behavior (subscript), enclose underscore in curly brackets:
%       {_} -> _    %subscript
%        _  -> \_   %literal underscore
%
% jri


str = strrep(str, '\_', '_');
str = strrep(str, '_', '\_');
str = strrep(str, '{\_}', '_');