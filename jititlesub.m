function jititlesub(text,sub,fs,option)
% JITITLESUB  Add a title and subtitle to current axis
%
%   jtitlesub(text, sub, [fontsize],['inside'])
%
%  default 14 point
%  if fontsize specified, uses that and normal weight
%  additionally, if 'inside' specified, places title inside axis (at top)
%   instead of above. Good for v. closely spaced panels 

fw='normal';	%for case when fontsize specified

if (nargin<3),
	fs=18;
	fw='bold';	%light, normal, demi, bold
end

subfs = round(fs*.75);
text = sprintf('\\fontsize{%d}\\bf%s\n\\fontsize{%d}\\rm%s',fs,protect_underscore(text),subfs,protect_underscore(sub));
h=title(text);
set(h,'verticalalignment','bottom')

if nargin==4 
   if strcmp(option,'inside')
      
       pos=get(h,'position');
        ax=axis;
        ytop=ax(4);
        ybot=ax(3);
        yrange = ax(4)-ax(3);
        if strcmp('reverse',get(gca,'ydir'))
            pos(2)=ybot+.025*yrange;
        else
            pos(2)=ytop;%-.025*yrange;
        end
        %pos(1) = pos(1)+.3;
        pos(3) = 1.1;
        set(h,'position',pos,'verticalalignment','top');
   else
      error('Incorrect option')
   end
end
