function cmap = redwhiteblue(N)
% REDWHITEBLUE  Colormap: blue thru white thru red, for distinguishing pos & minus
%
%
%      note: this doubles the size of the colormap, max size becomes 128
%
% JRI

if ~nargin,
    N = size(get(gcf,'colormap'),1)*2;
    if N > 128,
        N = 128; %yields a map of 128 entries
    end
end


top = [1 .1 0];
bot = [0 1 .1];
middle = 1;

upramp = [middle*ones(1,N/2) linspace(middle,1,N/2)]';
downramp = [middle*ones(1,N/2) linspace(middle,0,N/2)]';

revupramp = upramp(end:-1:1);
revdownramp = downramp(end:-1:1);
cmap = upramp * top + revupramp * bot;
cmap = cmap + downramp * (1-top) + revdownramp * (1-bot);
cmap = cmap/(max(max(cmap)));
cmap = brighten(cmap, -.8);

%set middle values to black
%cmap(round(N/2),:) = middle;
%cmap(round(N/2)+1,:) = middle;