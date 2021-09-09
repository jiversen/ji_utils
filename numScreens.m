function n = numScreens
% numScreens  return the number of displays attached to this computer
%
% n = numScreens
%
% used in determining figure positions in jisubplot
%
% code from fullscreen.m (Pithawat Vachiramon, file exchange)


ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
gds = ge.getScreenDevices();
n = length(gds);
