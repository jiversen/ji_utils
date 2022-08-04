function [rp, trp, urp, async, ipresound] = relphase(t, s1, s2, type)
% relphase  find relative phase between two time signals
%
%   [phase, t_phase, unwrapped, async, ipresound] = relphase(t, s1, s2, [type])
%
%   finds relative phase of s2 referred to s1

%   t_phase is time of events in s2 for which phase is reported (e.g. peak
%   times or event times)
%   unwrapped is unwrapped relphase (jumps > 0.5 in relative phase are unwrapped)
%   async = time to nearest event
%   ipresound = index into s1 to nearest event
%
%   optional scalar type selects relative phase between positive/negative peaks (+1/-1), 
%   or positive/negative going zerocrossings (+2/-2). Default is positive peaks
%
%   new option--if already have event times (currently assumes continuously
%   sampled timeseries-- call relphase([],s1, s2), where s1 and s2 are
%   event times
%
%
%   JRI 6/23/03 iversen@nsi.edu
%
%   4/17/08, redefined rp on (-0.5 0.5], from [0 1), placing zero phase in
%   midle of range, not at wrap-around point
%
%   8/1/22, added ipresound for use in synchronization experiments. 

if isempty(t)
    t1 = s1(:)';
    t2 = s2(:)';
else
    %expecting rows
    t  = t(:)';
    s1 = s1(:)';
    s2 = s2(:)';

    if nargin < 4
        type = 1;
    end

    if abs(type) > 1 %zero crossings
        filter = sign(type);
        t1 = zerocrossing(t,s1,filter);
        t2 = zerocrossing(t,s2,filter);
    else %peaks
        filter = sign(type);
        t1 = findpeaks(t,s1,filter);
        t2 = findpeaks(t,s2,filter);
    end
end

% ff=gcf;
% figure(30)
% plot(t1, 1./diff([0 t1]))
% plot_grid_y([36 44])
% plot(t2, 1./diff([0 t2]),'r')
% 
% pause
% figure(gcf)

%define measurement time intervals
ts = t1(1:end-1);
te = t1(2:end);
dt = te-ts;

rp = NaN*ones(size(t2)); %initialize rp to NaN
ipresound = NaN*ones(size(t2));
trp = t2;
%two ways to go--event by event (allows phase drift) or minimum phase--find
% interval each event lies in


%loop through intervals defined by first signal, assigning relative phase
%to events in second signal
for i = 1:length(ts)
    in = find(t2>=ts(i) & t2<te(i)); %all t2 within this interval
    if ~isempty(in)
        rp(in) = ( t2(in) - ts(i) ) ./dt(i);
        if rp(in)>0.5
          async(in) = t2(in) - te(i); %will be <0
          ipresound(in) = i+1;
        else
          async(in) = t2(in) - ts(i);
          ipresound(in) = i;
        end
    end
end

%shift so ranges +/- 0.5, w/ zero in middle
rp(rp>0.5) = rp(rp>0.5) - 1;

urp = unwrap(rp*2*pi)/(2*pi);

async(isnan(rp)) = nan;
