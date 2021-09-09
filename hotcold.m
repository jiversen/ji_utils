function cmap = hotcold(N)
% HOTCOLD  Colormap: hot thru black thru cool blues, nice for distinguishing pos & minus
%
%   colormap hotcold
%
%      note: this doubles the size of the colormap (I think it looks smoother). 
%       If you want a specific size, N, use colormap(hotcold(N))
%
%       To ensure 0=black, make sure caxis is symmetric about zero,
%           e.g. > caxis(max(abs(caxis))*[-1 1])
%
% Author: John Iversen (john_iversen@post.harvard.edu)
% Created: sometime in 1998

if ~nargin,
    N = size(get(gcf,'colormap'),1)*2;
    N = min(N,128); %clamp size at 128 entries.
end

%generate map: the upper part is from matlab's 'hot'; the lower part is simply reversed and permuted
h=hot(round(N/2)+4);
h = h(1:end-4,:); %get rid of extreme white endpoints
cmap = [h(end:-1:1,[3 2 1]); h];