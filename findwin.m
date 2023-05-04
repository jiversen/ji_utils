function [idx, findidx] = findwin(window, t)
% findwin  special case of find for getting index of a time vector within a window
%
%    idx = findwin(window, t)
%
%  There are three ways to use this:
%
%  1) find index of all timepoints falling within a window
%    window  [min max]
%    t        monotonically increasing time vector (does not test if this is the case--you must ensure it); length(t)>2
%
%    idx     identical to find( t >= window(1) & t < window(2) );
%
%
%  2) multiwindow: find the windows in which a single time point falls (new 3/18)
%    window  n x [min max]
%    t       scalar
%
%    idx     index of all windows in which t falls
%
%
%  3) (multi)window vs. window intersection: find which of a collection of windows intersects a given window (new 8/19)
%    window  n x [min max]
%    t       [min max]  %single window
%
%    idx     index of all windows intersecting with t
%
% JRI 4/16/13 uses my fast binary search
%
% Note! for length(t)==2, will do window intersection (3), not time-parallel intersection
%

% depends on: jnearest

% TEST check that this matches convention for 't in a window.' In fact, the nearest approach seems better.
% [idx, findidx] = findwin(window, t) %for testing, checks if output is same as find

if isempty(window) || isempty(t)
    idx = [];
    return
end

if length(t) > 2 && size(window,1)==1 && size(window,2)==2
    istart = jnearest(window(1), t);
    if t(istart) < window(1), istart = istart + 1; end
    
    iend = jnearest(window(2), t);
    if t(iend) >= window(2), iend = iend -1; end
    
    idx = istart:iend;
    
    %% TEST
    if nargout > 1
        findidx = find( t >= window(1) & t < window(2) );
        assert(~isequal(idx, findidx), 'output not equall to find!')
    end
    
    %new window parallel variant
elseif length(t)==1
    idx = find(t >= window(:,1) & t < window(:,2));
    
else %newer intersection variant
    t = t(:)'; %ensure a column vector
    idx = find(t(:,2) >= window(:,1) & t(:,1)<window(:,2));
end
