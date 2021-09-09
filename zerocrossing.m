function [zc, nearest] = zerocrossing(t,sig, filter)
% zerocrossing  Find zerocrossings of a time signal
%
%   zc = zerocrossing(t,sig, [filter])
%
%   filter is optional scalar. If +1, return only positive slope zero
%   crossings, if -1, only negative slope crossings. If unspecified,
%   returns all zerocrossings.
%
%   uses simple linear interpolation to estimate the actual time of zero
%   crossing, since it usually lies between two sample points
%
%   JRI 6/23/03 iversen@nsi.edu

if nargin==0,
  eval(['help ' mfilename])
  return
end

sig = sig(:).'; %ensure row
t = t(:).';
dt = t(2)-t(1);
d = diff(sign(sig));
idx = find(abs(d) > 1); %index to first of two points spanning across zero

%simple linear interpolation
p1 = sig(idx); %p1 to p2 spans y=0
t1 = t(idx);
p2 = sig(idx+1);
dy = p2-p1;
u = -p1./dy;
zc = t1+u*dt;
slope = dy/dt;
%find index of nearest sample
p1d = zc-p1;
p2d = p2-zc;
p2close = sign(p1d-p2d); %+1 if p2 is closest, -1 if p1
%idx points to p1, so increase by one those cases when p2 is closer
nearest = idx + (p2close > 0);

%filter
if nargin > 2,
    good_idx = find(sign(slope) == sign(filter));
    zc = zc(good_idx);
end