function [relphase, cdiff, hsig, href] = hilrelphase(t,sig,refsig,sigfreq,refsigfreq)
% hilrelphase   hilbert relative phase between two signals
%
%   [relphase, cdiff] = hilrelphase(t,sig,refsig[,sigfreq,refsigfreq])
%
%   INPUTS
%       t           time axis
%       sig         can be multi-channel (channel x samples)
%       refsig      reference signal (1 x samples)
%       sigfreq     optional, central freq of sig, used to demodulate phase
%       refsigfreq  
%
%   OUTPUTS
%       relphase  relative phase
%       cdiff     complex difference between hilbert transforms of sig & refsig
%       hsig      hilbert transform of sig, demodulated if sigfreq was specified
%       href      hilbert transform of reference signal
%
%   JRI 10/15/04

dt=t(2)-t(1);
[chans, samples]=size(sig);
if samples==1, sig=sig.'; chans=1;end %in case passed as column
refsig = refsig(:).'; %make row

hsig = hilbert(sig.').';
href = hilbert(refsig);

%handle non-equal frequencies--demodulate
if nargin > 3,
    t = t(:)'; %row
    href = href .* exp(-i*2*pi*refsigfreq*t);
    sigfreq = sigfreq(:);
    if length(sigfreq)==1,
        sigfreq = sigfreq * ones(chans,1);
    end
    hsig = hsig .* exp(-i*2*pi*sigfreq*t);
end

hrefconj = conj(href);
cdiff = hsig.*hrefconj(ones(1,chans),:);
relphase = unwrap(angle(cdiff), [], 2)/(2*pi);
