function [tif, ifreq] = instfreq(t, s1, type)
% instfreq  simple instantaneous frequency (rate between peaks or zero crossings)
%
%   [t_ifreq, ifreq] = instfreq(t, sig, [type])
%
%   t_ifreq is time base
%   ifreq is instantaneous frequency
%
%   optional scalar type selects frequency calculated between 
%   positive/negative peaks (+1/-1), or
%   positive/negative going zerocrossings (+2/-2). 
%   or all peaks (10)
%   or all zeros (20)
%
%   Default is positive peaks
%
%   JRI 2003
%
%   10/15/04 for better time resolution, calculate on half-cycles 

if nargin < 3,
    type = 1;
end

fscale = 1;
switch abs(type)
    case 1, %peaks
        filter = sign(type);
        t1 = findpeaks(t,s1,filter);
    case 2, %zero crossings
        filter = sign(type);
        t1 = zerocrossing(t,s1,filter);
    case 10,
        t1 = findpeaks(t,s1);
        fscale = 0.5;
    case 20,
        t1 = zerocrossing(t,s1);
        fscale = 0.5;
end

t1 = unique(t1);

%define measurement time intervals
ts = t1(1:end-1);
te = t1(2:end);
dt = te-ts;
ifreq = (1./dt) * fscale;
tif = t1(1:end-1)+dt/2; %points midway between events to ascribe frequency to