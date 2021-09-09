function hout = plot_fft(power, freq, y_lim, grid_x)
% plot_fft  plot powerspectrum of relevance to frequency tagging
%
%   h = plot_fft(power, freq, y_lim, grid_x)
%
%       power   one row of data (e.g. as returned by calc_fft)
%       f       frequency axis
%       y_lim   optional. specifies y limits of plot. also use default if = []
%       grid_x  optional. specifies guidelines do draw to indicate freqs
%
%       h       handle to line
%
%   JRI, split from calc_fft, 1/27/03

%if size(power,1) > 1,
%    disp('multirow result, only plotting first')
%end
%yy = power(1,:);
yy = power;
if nargin >= 3 && ~isempty(y_lim),
    y_tic = [y_lim(1) 0.5*y_lim(2)];
else
    y_tic = [min(min(yy(:,2:end))) 0.5*max(max(yy(:,2:end)))]; %max of non-dc terms
    y_lim = [0 max(max(yy(:,25:end)))]; %max of non-dc terms
end

if nargin < 4,
    grid_x = [1 3.16 10 20 30 40]; %appropriate for MEG, tags
    grid_x = [];
end

plotgrid(grid_x,y_tic,[],[]); 
hold on
set(gca,'tickdir','out')

h = plot(freq, yy,'k-');
%semilogy(freq(pos_idx), yy,'k-')

ylim(y_lim)
xlim([0 65])

ylabel('PSD')
xlabel('Frequency')

if nargout,
    hout = h;
end

