function [idx, findidx] = findwin(window, t)
% findwin  special case of find for getting index of a time vector within a window
%
%    idx = findwin(window, t)
%
%    window  [min max]
%    t        monotonically increasing time vector (does not test if this is the case--you must ensure it)
%
%    idx     identical to find( t >= window(1) & t < window(2) );
%
%   TODO check that this matches convention for 't in a window.' In fact, the nearest approach seems better.
%
% JRI 4/16/13 uses my fast binary search

% [idx, findidx] = findwin(window, t) %for testing, checks if output is same as find

istart = jnearest(window(1), t);
if t(istart) < window(1), istart = istart + 1; end

iend = jnearest(window(2), t);
if t(iend) >= window(2), iend = iend -1; end

idx = istart:iend;

%% test
if nargout > 1,
    findidx = find( t >= window(1) & t < window(2) );
    require(isequal(idx, findidx), 'output not equall to find!')
end