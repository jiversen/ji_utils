function [amp, phase, tifreq, ifreq] = hilanal(t,sig)
% hilanal   hilbert transform analysis
%
%   [amp, phase, tifreq, ifreq] = hilanal(t,sig)
%
%       sig can be multi-channel (channel x samples)
%
%   envelope, phase, timebase for inst.freq, inst.freq
%
%   inst. freq defined as derivative of phase
%
%   JRI 10/15/04

if nargin==0,
  eval(['help ' mfilename])
  return
end

if isvector(sig),
    sig = sig(:).';
end

dt = t(2)-t(1);
hsig = hilbert(sig.').';
amp = abs(hsig);
phase = unwrap(angle(hsig), [], 2);
ifreq = diff(phase,1,2)/(2*pi*dt);
tifreq = t(1:end-1) + dt/2; %place time of estimate mid way between original points