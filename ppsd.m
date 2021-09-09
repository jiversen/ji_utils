function [freq_out, psd_out, fpeak, psdpeak] = ppsd(x,dt,c,doPlot, df)
% ppsd  plot psd
%
%   [F, psd, F_peak, psd_peak] = ppsd(x,dt,color,[doPlot], df)
%
%       plots psd, optionally returning psd and location of peaks (>3sd from
%       mean)
%       color is color letter + optionally, linestyle
%       doPlot default yes, false or 0 to suppress
%
%       x   one or more columns of data
%
%   OR, single argument of struct from loadB

if nargin==0,
    help ppsd
    return
end

if isstruct(x),
  B = x;
  x = B.B(:,1:148);
  dt = B.dt;
end

if nargin < 4,
    doPlot = true;
end

if nargin < 5,
  df = length(x);
end

x(isnan(x))=[];
x = x - (ones(size(x,1),1)*mean(x));

[Fnn, freq, psd, N_fft] = calc_fft(x, dt, df);%,1/15); %why?

if doPlot,
    h = plot_fft(psd, freq);

    if nargin > 2,
        set(h,'color',c(1));
        if length(c)>1,
            set(h,'linestyle',c(2:end))
        end
    end
end

if nargout,
    freq_out = freq;
    psd_out = psd;
end
    
if nargout > 2,
    [fpeak, psdpeak] = findpeaks(freq,psd,'pos',3);
end
