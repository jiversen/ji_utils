%argh, sort out units issues for power and energy
%   this time, I've got it: power spectrum, power spectral density
% JRI 8/22/03

Fs = 500;
dt = 1/Fs;

NFFT = 2000;
df = Fs / NFFT; %(bin spacing in fft)

%one and two second stimuli
t = 0:1/Fs:1-1/Fs;
N = length(t);
t2 = 0:1/Fs:4-1/Fs;
N2 = length(t2);

freq = 10;
x = sin(2*pi*freq*t)+ .5*cos(2*pi*freq/2*t);
%x = randn(size(t));
x2 = sin(2*pi*freq*t2) + .5*cos(2*pi*freq/2*t2);
%x2 = randn(size(t2));

%sine of amplitude 1 has power 1/2
% sine of amplitude x has power (x^2)/2

Ex = sum(x.^2) * dt %a more physically motivated integration, 0.5
Ex2 = sum(x2.^2) * dt

% Power is energy / T, but T = N * dt so dt cancels
%  wrong: Px is still Ex / T, since multiplied by dt above
%Px = Ex / N
%Px2 = Ex2 / N2
%We still have to divide by T
Px = Ex / (N*dt) % is 0.5, naturally, since only 1 sec
Px2 = Ex2 / (N2*dt) %also correctly normalized to 0.5
%* Note, these simplify to Px = sum(x.^2) / N;

%now look at power spectrum (single long window)
%windowed DFT
w1 = hanning(N)';
w2 = hanning(N2)';
y = fft(x.*w1, NFFT);
y1b = fft(x.*w1, NFFT/2);
y2 = fft(x2.*w2, NFFT);
%power
PS = abs(y).^2 / norm(w1)^2; 
PSb = abs(y1b).^2 / norm(w1)^2;

%aside: compare to spectrum
[cs2, F2]  = spectrum(x.*w1, NFFT, 0, w1, 1/dt);


% Note on integration:
% these are equivalent curves, but sum PSb = sum(PS)/2 'cause it has half the points
%  shows that changing NFFT does not cause energy to be spread around, but
%   just changes the sampling--so the PS is same but when integrating, PSb
%   has bins twice as wide. In short, behaves as integrable
% so sums must be multiplied by approproate df:

PS = PS * df;  %df = Fs/NFFT = 1/ (dt * NFFT) = 1/Tfft
PSb = PSb * (2*df); %both sum to 250 = sum(x.^2)

%going well, now if instead of PS we use PSD (divide by Fs = multiply by dt)
PSD = PS / Fs;   %summed, we get correct energy/power (since T=1)
PSDb = PSb / Fs;

%  PSD simplifies to (abs(y)^2 / norm(win)^2) / NFFT !
%  we don't need to normalize the PSD by T--it's already power. Time is normalized
%       out when we divide by norm(win)^2!

%Power equivalence relation: a windowed, padded version of parseval's equality
sum(x.^2) / N
%(sum(abs(y).^2) / norm(w1)^2) * Fs / (NFFT*N) %NO
(sum(abs(y).^2) / norm(w1)^2) / NFFT % = sum(PSD) YES

%now for double length signal
PS2 = abs(y2).^2 / norm(w2)^2 * df;
PSD2 = PS2 / Fs;  %this summed equals the power

%this sum is identical to PS, nice because they have same power
%  however not identical as func of freq, due to windows being different--
%   the longer signal has the sharper (and therefor higher) freq peak

%equivalence
sum(x2.^2) / N2 %right 0.5
(sum(abs(y2).^2) / norm(w2)^2)  / (NFFT) 

%%finish up, generate frequency vector and wrap
F = Fs * [0:NFFT-1]/NFFT;
pos_idx = [1:NFFT/2+1]; %we know NFFT is even, this is [0, Fs/2]

Fb = Fs * [0:NFFT/2-1]/(NFFT/2);
pos_idxb = [1:NFFT/4+1]; %we know NFFT is even

%% return one-sided functions
%for even
PSD = PSD(pos_idx);
PSD = [PSD(1) 2*PSD(2:end-1) PSD(end)]; %wrap neg-freq power around (real sig, PSD symm)
F = F(pos_idx);

%sum under curve nicely returns power in each sinusoid
%  question: what can one tell from the amplitude of the power peak? This'll depend
%   on the windowing function, as well as fft length?

