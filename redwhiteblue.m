function cmap = redwhiteblue(N)
% REDWHITEBLUE  Colormap: blue thru white thru red, for distinguishing pos & minus
%
%   colormap redwhiteblue
%
%
%      note: this doubles the size of the colormap (I think it looks smoother). 
%       If you want a specific size, N, use colormap(redwhiteblue(N))
%
%       To ensure 0=black, make sure caxis is symmetric about zero,
%           e.g. > caxis(max(abs(caxis))*[-1 1])
%
% Author: John Iversen (john_iversen@post.harvard.edu)
% Created: sometime in 2002


if ~nargin,
    N = size(get(gcf,'colormap'),1)*2;
    N = min(N,128); %clamp size at 128 entries.
end

top = [1 0 0];
bot = [0 0 1];
middle = 1; %gray level of middle value: 1=white, 0=black

%pre-brighten extreme colors slightly, later darken entire map
bright  = [0 .1 0];
beta    = -0.8;
bright = [0 0 0]; beta = 0; %don't
top     = top + bright;
bot     = bot + bright;

upramp      = [middle*ones(1,N/2) linspace(middle,1,N/2)]';
downramp    = [middle*ones(1,N/2) linspace(middle,0,N/2)]';
revupramp   = upramp(end:-1:1);
revdownramp = downramp(end:-1:1);

cmap = upramp * top + revupramp * bot;
cmap = cmap + downramp * (1-top) + revdownramp * (1-bot);
cmap = cmap/(max(max(cmap)));
cmap = brighten(cmap, beta);
