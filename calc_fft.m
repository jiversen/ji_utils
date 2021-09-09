function [Fnn, freq, power, N_fft] = calc_fft(data, dt, fft_len,option)
% calc_fft  Calculate fft & power spectrum (convenience function)
%
%   [Fnn, freq, PSD, N_fft] = calc_fft(data, dt, fft_len,option)
%
%   INPUT
%       data        one or more columns of data. FFT of each column of data is calculated.
%       dt          sample interval
%       fft_len/df  optional. If unspecified, uses actual length of data
%                   if a value >= data length, use that length for fft
%                   if a value <= 10, interpret as desired df and set
%                    fft length to round(1/(df*dt))
%       option      'nowin' do not window, otherwise uses hanning, length of data
%
%   OUTPUT
%       Fnn       FFT result (complex result of fft, non-neg freqs only)-row per channel 
%       freq      freq base for fft
%       PSD       'power spectral density', to get power sum(PSD) / (N_fft*dt)
%                   i.e. divide by fft length in seconds
%
%   JRI 2002, 9/2003 (power)
%
%   note data is zero-mean'ed before fft


if nargin==0,
  eval(['help ' mfilename])
  return
end

if nargin < 4,
  doWin = true;
else
  doWin = false;
end

if size(data,1) == 1,
    data = data(:);
end
len     = size(data,1);
chans   = size(data,2);

data(isnan(data))=0;

% window the data
if doWin,
    win     = repmat(hanning(len), 1, chans);
    data    = data .* win;
    clear win
end

% choose fft length based on desired frequency resolution
%N_fft = 1017;  %gets a bin close to 41.5 (41.51)
%N_fft = ceil(N_fft*dt)/dt;
if nargin >= 3,
    if fft_len >= len,
        N_fft = fft_len;
    elseif fft_len <= 10, %intrepret as df
        df = fft_len;
        N_fft = round(1/(dt*df));
    else
        warning('fft_len less than data length: truncating data')
        data = data(1:fft_len,:);
        N_fft = fft_len;
    end
else
    N_fft = len;
end

%data: channel (row) x time (col), fft over column -> channel x frequency
%calculate freq base & non-neg frequencies (from specgram.m)
if rem(N_fft,2),    % N_fft odd
    nonneg_idx = [1:(N_fft+1)/2];
else
    nonneg_idx = [1:N_fft/2+1];
end
Fs      =1/dt;
freq    = (nonneg_idx - 1) * Fs/N_fft;

F = fft(data, N_fft);

%Fnn=F(nonneg_idx,:)'; %ERROR in phase, before 10/29/07 returned conjugate of correct answer
Fnn=F(nonneg_idx,:).'; %phase ok. return in row order for historical reasons

%calculate power spectrum
%  assuming input is real, we wrap neg frequencies around & therefore
%  multiply power at positive frequencies by 2
% NB: this is inconsistent, as len refers to original signal (pre-padding)
%     while N_fft is the longer, padded, signal. 
if doWin,
  power = (abs(Fnn).^2)./ norm(hanning(len))^2;
else
  power = (abs(Fnn).^2)./ (N_fft^2);
end
%power(:,2:end) = power(:,2:end)*2; %very slow!
%OPTIMIZE, no better
% mul = ones(chans,1) * [1 2*ones(1,size(power, 2)-1)];
% power = power .* mul;
% clear mul
%OPTIMIZE2, huge gain --from >10 s to <.1;
power = power*2;
power(:,1) = power(:,1)/2;
power = power * dt;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tests--verify power spectrum calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doVerify = 0;
if doVerify,
    error_threshold = 1e4;
    data = data - mean(data);
    a1=sum(data.^2, 1); %sum down columns
    a2=(1/N_fft)*sum(abs(F).^2, 2);
    if  any(abs(a1-a2) > max(a1)/error_threshold),
        a1-a2
        warning('full parseval failed')
        %keyboard
    end
    if N_fft == len, %hack: this fais if not, but haven't had time to sort it out
        b1=(1/N_fft)*a1;
        b2 = sum(power,2);
        if any(abs(b1-b2) > max(b1)/error_threshold),
            b1-b2
            warning('wrapped power failed')
            %keyboard
        end
        %fprintf('SS=%g, power=%g\n',a1, b2)
    end
end
