function [idx, d]=jnearest(point, collection)
% jnearest   find index into a collection of element nearest to a point
%
%       [idx, dist] = jnearest(point, collection)
%
%  INPUTS
%       point           1 x N, vector of points to individually lookup
%       collection      1 x M, vector to search  (must be sorted ascending)
%
%
%  OUTPUTS
%       idx             1 x N, nearest index into collection
%       distance	1 x N, euclidian distance to nearest point (optional)
%
%
% JRI 03/22/2006
% JRI 1/18/13 use fast binary search (see filechachange closest_value, Benjamin Bernard)
%  For future, consider using MEX binary search: http://www.mathworks.com/matlabcentral/fileexchange/30484-fast-binary-search
% 4/22/14 -- fix to reenable vector of points

from = 1;
to = length(collection);

nPoint = size(point,2);

if nPoint>1
  for iP = 1:nPoint
    [idx(iP), d(iP)] = jnearest(point(iP),collection);
  end
else
  
  %binary search
  while to-from > 1
    mid = floor((from+to)/2);
    d = collection(mid) - point;
    if d == 0
      idx = mid;
      d = 0;
      return
    elseif d < 0
      from = mid;
    else
      to = mid;
    end
    
  end
  
  %tiebreaker
  if to-from==1 && (abs(collection(to) - point) < abs(collection(from) - point))
    from=to;
  end
  
  idx = from;
  if nargout==2
    d = sqrt( (collection(idx) - point).^2 );
  end
  return
end

% ==== old implementation -- much too slow for long vectors

if nargin==0,
  eval(['help ' mfilename])
  return
end

psize = size(point);
ndim = psize(2);
if (psize(1)~=1), error('point must be 1 x N'); end

csize = size(collection);
%special case--a single row, make a column
if csize(1)==1 && csize(2) > 1,
    collection = collection.';
    csize = size(collection);
end
numitems = csize(1);
%special case--if a single column and ndim > 1, repeat the column ndim times
if csize(2)==1 && ndim > 1,
   collection = repmat(collection, [1 ndim]);
   csize = size(collection);
end
if csize(2) ~= ndim, error('collection must have same number of columns as does point'); end

%dist = sqrt( sum( (ones(numitems,1)*point - collection).^2, 2));
dist = sqrt( (ones(numitems,1)*point - collection).^2 );
[junk, idx] = min(dist,[],1);
if nargout==2,
    d=junk;
end

