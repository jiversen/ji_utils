function jixlabel(text,fs)
% jixlabel  JRI's version of XLABEL with control of fontsize.
%   jxlabel(text,[fs])  --defaults to 14 pt, demi weight


fw='normal';

if nargin==1,
    fs= 2 + get(gca,'fontsize');
    fw = 'demi';
end

text = protect_underscore(text);
xlabel(text,'FontSize',fs,'FontWeight',fw)
