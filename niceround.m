function [b, strout, shortstrout] = niceround(a,r)
% niceround Round a number 'up' to the nearest 'nice' one: M x 1eN, M,N int
%
%   b = niceround(a)
%
%   [b, str, [shortstr] ] = niceround(a)  % also returns a nice string
%
%   b = niceround(a,resolution)
%
%   rounds in steps size of resolution. Default is 1, 0.5 rounds in half steps
%       (1.1 -> 1.5), 0.1 rounds in tenths, 10 to nearest tens, etc.
%
%   if resolution <= 0, interpreted as log10 defining decimal position relative
%     to order of magnitude. E.g. -1, rounds numbers [10,100) to nearest 1
%
% %treats .1 to 1000 specially: ok to have maintissa < 1, no exp
%
%   JRI 1/28/03

if nargin < 2,
    r = 1;
end

l10 = log10(a);

if r <= 0,
  r = 10 ^ (r + floor(l10));
end

if (l10>=-1 && l10<3), %treat .1 to 1000 specially: ok to have maintissa < 1, no exp
    N = 0;
    if a>=0,
        M = r*ceil((a*10)/(r*10));
    else
        M = r*floor((a*10)/(r*10));
    end
    b = M;
    str = num2str(b,2);
    shortstr = str;
else
    N = floor(l10);
    if a>=0,
        M = r*ceil(a/(r*10^N));
    else
        M = r*floor(a/(r*10^N));
    end
    b = M*(10^N);
    str = sprintf('%d x 10^%d', M, N);
    shortstr = sprintf('%de%d',M, N);
end

if nargout > 1,
    strout = str;
end
if nargout > 2,
    shortstrout = shortstr;
end

