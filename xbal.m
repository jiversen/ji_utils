function xbal(lim)
% xbal balance xlim of plot
%
%   axis limits spanning 0, makes symmetric
%
%   ybal(lim): create axis with symmetric limit +/- lim


xl=xlim;

if prod(xl) < 0,
    m=niceround(max(abs(xl)),0.5);
    if nargin,
        m = lim;
    end
    xlim(m*[-1 1])
else

    %also, if zero is within 1/10 of span, include it
    edge = diff(xl) / 10;
    xln = [xl(1)-edge xl(2)+edge];
    if prod(xln) < 0,
        if xl(1)>0,
            xl(1) = xl(1) - edge*1.1;
            if nargin,
                x(2) = lim;
            end
        else
            xl(2) = xl(2) + edge*1.1;
            if nargin
                x(1) = -abs(lim);
            end
        end
        xlim(xl)
    end

end

gridx
