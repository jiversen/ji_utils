function cmap = redgreen(N)
% REDGREEN  Colormap: green thru black thru red, for distinguishing pos & minus
%
% JRI

if ~nargin
    N = 64;
end

top = [1 .1 0];
bot = [0 1 .1];
bias = .1 * ones(N,1) * [0 0 0];

ramp = (2/N) * [zeros(1,N/2) 1:N/2]';
revramp = ramp(end:-1:1);
cmap = ramp * top + revramp * bot;
cmap = cmap + bias;
cmap = cmap/(max(max(cmap)));
cmap = brighten(cmap, -.4);

%set middle values to black
cmap(round(N/2),:) = 0;
cmap(round(N/2)+1,:) = 0;