function [t_peak, a_peak, w_peak] = jifindpeaks(t,sig,sign,sdthresh)
%findpeaks  Find time of peaks of a signal
%
%   [t_peak, a_peak, w_peak] = findpeaks(t,sig,sign,sdthresh)
%
%   finds peaks of signal sig. 
%       if sign unspecified, or 'all' finds both positive and negative peaks
%           sign can also be 'pos' or 'neg' to return only those peaks
%       sdthresh specifies an amplitude reject threshold at sdthresh*sd of signal 
%
%   method: finds interpolated zerocrossings of 1st derivative
%
%   t_peak = interpolated time of peak
%   a_peak = amplitude of peak
%   w_peak = width of peak (at half amplitude)
%
%   note--amplitude estimate suffers from being only linear--caveat emptor
%
%   JRI 6/23/03 iversen@nsi.edu

%to do: perform some kind of culling depending on 2nd derivative to eliminate
%inflection points?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input parameters
if nargin >= 3,
    if ischar(sign),
        switch lower(sign), %convert text to value of filter
            case 'all'
                filter = 0;
            case 'pos'
                filter = 1;
            case 'neg'
                filter = -1;
            otherwise
                error('invalid value for sign')
        end
    else
        filter = sign;
    end
end
if nargin < 4,
    sdthresh = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find peaks--interpolated zerocrossing of derivative
dt = t(2)-t(1);
tt = t(1:end-1)+dt/2; %points midway between samples
dy = diff(sig);
my = nanmean(sig);

if (nargin <3 || filter == 0),
    t_peak = zerocrossing(tt,dy);
else %filter peaks
    t_peak = zerocrossing(tt,dy, -filter); %pos peak is negative slope
end

%find peak amplitudes
% add true zeros in original derivative
%   this merely yields value at t_peak equal to the max of neighboring values,
% peakLoc     = [zeros(size(tt)) ones(size(t_peak))];
% tt          = [tt t_peak];
% [tt, iSort] = sort(tt);
% dy          = [dy zeros(size(t_peak))];
% dy          = dy(iSort);
% peakLoc     = peakLoc(iSort);
% peakIdx     = find(peakLoc == 1);
% newsig      = cumsum(dy);
% newt        = sort([t t_peak]);
% a_peak      = newsig(peakIdx);

%%new method for finding amplitude--find interpolated value using t_peak
a_peak = interp1(t,sig,t_peak, 'spline');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter peaks on stdev--doesn't rid us of small peaks riding on larger ones
if ~isempty(sdthresh),
    sd = nanstd(sig);
    iGood = find((abs(a_peak)) > sd * sdthresh); %had -nanmean(a_peak), but that only works if all peaks collected
    t_peak = t_peak(iGood);
    a_peak = a_peak(iGood);
end

% what we really want is to excluded peaks based on height relative to surroundings
%   to do this: take all peaks +&- and find 'peak height' as function of difference from line
%   connecting neighboring peaks of opposite sign (eval at this peak location)--e.g. subtract it from
%   a linear interpolation

%% find peak width
if nargout > 2,
  if isempty(t_peak),
    w_peak=[];
    return
  end
  iPeak = jnearest(t_peak, t);
  w_peak = zeros(size(iPeak));
  neighborhood = 2; %take three points on either side of peak
  
  for iP = 1:length(iPeak),
    idx = iPeak(iP)+[-neighborhood:neighborhood];
    idx(idx<1)=[];
    idx(idx>length(sig))=[];
    xx = t(idx);
    yy = sig(idx);
    xx=xx(:); yy=yy(:);
    %from http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm
    [coef,S,MU]=polyfit(xx,log(abs(yy)),2);  % Fit parabola to log10 of sub-group with centering and scaling
    c1=coef(3);c2=coef(2);c3=coef(1);
    PeakX=-((MU(2).*c2/(2*c3))-MU(1));   % Compute peak position and height of fitted parabola
    PeakY=exp(c1-c3*(c2/(2*c3))^2);
    MeasuredWidth=norm(MU(2).*2.35703/(sqrt(2)*sqrt(-1*c3)));
    w_peak(iP) = MeasuredWidth;
  end
end
