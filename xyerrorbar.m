function xyerrorbar(x, y, color)
% xyerrorbar plot points with x and y errorbars
% 
%   xyerrorbar(x, y, color)
%
%  INPUTS
%   x, y  units vs. replications (e.g. subject x trial)
%   color  letter or rgb vector
%
%  OUTPUTS
%   
%   
%
% JRI %7/9/12

global G

if nargin==0,
  eval(['help ' mfilename])
  return
end

if nargin < 3,
  color = 'b';
end

[nObs, nRpt] = size(x);

hold on
for iObs = 1:nObs,
  mx = nanmean(x(iObs,:));
  my = nanmean(y(iObs,:));
  
  sdx = std(x(iObs,:));
  sdy = std(y(iObs,:));
  
  sex = sdx / sqrt(nRpt);
  sey = sdy / sqrt(nRpt);
  
  errx = sex;
  erry = sey;
  
  plot(mx,my,'.','color',color)
  plot([mx-errx mx+errx], [my my], '-','color',color)
  plot([mx mx], [my-erry my+erry], '-','color',color)
end

  