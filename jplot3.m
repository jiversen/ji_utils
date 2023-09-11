function hout=jplot3(dat, style, varargin)
%jplot3 wrapper to plot 3 to allow passing (Nx3) matrix, from which it takes x,y and z
%
%   h=jplot3(dat, style, varargin)
%       
%       dat is Nx3 (or 3xN)
%       style is optional
%       varargin are param/value pairs passed on to plot3
%
%       h is handle vector returned by plot3
%
%   JRI 4/21/08

if nargin==0,
    eval(['help ' mfilename])
    return
end

if nargin < 2,
    style = 'b-';
end

if ( ~any(size(dat)) == 3 || ndims(dat) ~= 2 ),
    error('jplot3: data must be Nx3, or 3xN')
end

%find which dimension is 3, reorder to 3 columns
if size(dat, 1) == 3,
    dat = dat.';
end

%better way, if len varargin is odd, take style as first entry
if nargin > 1,
    h = plot3(dat(:,1), dat(:,2), dat(:,3), style, varargin{:});
elseif isempty(style) && nargin > 2
    h = plot3(dat(:,1), dat(:,2), dat(:,3), varargin{:});
else
    h = plot3(dat(:,1), dat(:,2), dat(:,3));    
end

%optimization - only setup axes once. Greatly speeds repeated calls to it
if ~strcmp(get(gca,'tag'),'JPLOT3'),
  axis vis3d, axis equal
  grid on
  box on
  xlabel('x'),ylabel('y'),zlabel('z')
  rotate3d on
  set(gca,'tag','JPLOT3')
end

if nargout,
    hout = h;
end


