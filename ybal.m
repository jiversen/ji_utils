function ybal(lim)
% ybal balance ylim of plot
%
%   axis limits spanning 0, makes symmetric
%
%   ybal(lim): create symmetric (round 0) axis with limit lim


yl=ylim;

if prod(yl) < 0,
  %m=niceround(max(abs(yl)),0.1);
  m = max(abs(yl))*1.1;
  if nargin,
    m = lim;
  end
  ylim(m*[-1 1])
else
  
  %also, if zero is within 1/10 of span, include it
  edge = diff(yl) / 10;
  yln = [yl(1)-edge yl(2)+edge];
  if prod(yln) < 0,
    if yl(1)>0,
      yl(1) = yl(1) - edge*1.1;
      if nargin,
        y(2) = lim;
      end
    else
      yl(2) = yl(2) + edge*1.1;
      if nargin
        y(1) = -abs(lim);
      end
    end
    ylim(yl)
  end
  
end

gridy
