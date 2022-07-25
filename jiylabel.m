function jiylabel(text,fs)
% JIYLABEL  JRI's version of YLABEL with control of fontsize.
%   jylabel(text,[fs])  --defaults to axis + 2 pt, demi weight


fw='normal';

if nargin==1,
    fs= 2 + get(gca,'fontsize');
    fw = 'demi';
end
text = protect_underscore(text);
h = ylabel(text,'FontSize',fs,'FontWeight',fw);
%nudge closer to axis
set(h,'units','normalized')
p=get(h,'position');
p(1)=p(1)+.015;
set(h,'position',p);
