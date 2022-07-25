function hout = jititle(text,fs,option)
% JITITLE  JRI's version of TITLE with control of font size.
%
%   h = jtitle(text,[fontsize],['inside'])
%
% jri wrapper for axis title:
%  default axis + 4 point bold
%  if fontsize specified, uses that and normal weight. fs<0 uses default
%  additionally, if 'inside' specified, places title inside axis (at top)
%   instead of above. Good for v. closely spaced panels 

fw='normal';	%for case when fontsize specified

if nargin == 2,
    if ischar(fs),
        option = fs;
    else
        option = '';
    end
end

if nargin==1 || ischar(fs) || fs < 0,
    fs= 4 + get(gca,'fontsize');
    fw = 'bold';
end


text = protect_underscore(text);
h=title(text,'FontSize',fs,'FontWeight',fw);
set(h,'verticalalignment','middle')

if nargin >= 2 
    if strcmp(option,'inside')
        
        pos=get(h,'position');
        ax=axis;
        ytop=ax(4);
        ybot=ax(3);
        yrange = ax(4)-ax(3);
        if strcmp('PLOT_HEAD',get(gca,'tag')),
            pos(2) = 7;
        else
            pos(2)=ytop-.01*yrange;
        end
        %pos(1) = pos(1)+.3;
        set(h,'position',pos,'verticalalignment','middle');
    else
        %error('Incorrect option')
   end
end

if nargout,
    hout = h;
end
