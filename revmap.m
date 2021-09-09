function cmap = revmap(cmap)
% revmap    reverse colormap
% JRI iversen@nsi.edu 6/11/2007

cmap = cmap(end:-1:1,:);
