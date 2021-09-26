function expmulti(varargin)
% expmulti  Export all plots prepared with jisubplot/nextplot.
%
%   expmulti(type, fname, [resolution])
%   expmulti(fig, type, fname, [resolution],[noshow])
%
%   INPUTS
%       type        export type: 'tiff', 'epsc2', 'jpeg90', etc (from print.m)
%       fname       base for filename
%       resolution  [optional] number in ppi, default is 300
%       noshow      true, don't open FIGS directory after export
%
%   if a name is specified,
%     Images are saved to 'fname_timestamp_N', where N is fig number, 
%     into G.paths.figpath/subdirectory according to today's date
%   if a full path (beginning with /) is specified, uses that filename and path
%
%  Like PRINTMULTI.
%
% JRI 10/12/99, 10/16/04 (iversen@nsi.edu)

if ~nargin,
    help expmulti
    return
end

global G

try
    figpath = G.paths.figpath;
catch
    figpath = fullfile(userhome,'FIGS');
end

doAllFigs = 1; %do all figs, not just jisubplot figs

set(0,'showhiddenHandles','on') %make sure we pick up hidden figs, like anova results

if isnumeric(varargin{1})
  figs = varargin{1};
  varargin(1)=[];
elseif ishandle(varargin{1})
  figs = varargin{1}.Number;
  varargin(1)= [];
else
  figs=get(0,'Children');
end

global G

n=length(varargin);
if nargin < 2,
    error('Usage: expmulti(type, fname, [resolution])')
else
    type = varargin{1};
    fbase = varargin{2};
end
if n < 3,
    resolution = 200;
    %default resolution for *ps seems to affect how smoothly curves are rendered
    if ~isempty(strfind(lower(type),'ps')),
        resolution = 1200;
    end
else
    resolution = varargin{3};
end

if n < 4,
  noshow = false;
else
  noshow = varargin{4};
end

resStr = sprintf('-r%d', round(resolution));

%make extension
switch (lower(type(1:3))),
    case 'jpe',
        extension = 'jpg';
    case 'psc',
        extension = 'ps';
    otherwise
        extension = lower(type(1:3));
end

%single timestamp for entire set of figures exported with one call
[~, fstamp]=timestamp;
dstamp=fstamp(1:10);
tstamp=fstamp(12:end);

for fig=figs',
   
  tag = get(fig,'tag');
  figNo = get(fig,'Number'); %2014b fix
  %figNo = fig;
  if strcmp(tag,'EEGLAB'), continue; end %skip eeglab's main window
  
   ud=get(fig,'userdata');
   if doAllFigs || ~isempty(ud),
      figure(fig);
      if strcmp(extension,'jpg') || strcmp(extension,'tiff'),
        
        %set(gcf,'renderer','zbuffer'); %hack necessary to print color @ NSI (with R13)
        %                                seems no longer needed for R14
        % 10/11 IS necessary to render some opengl scenes. Loses transparency,
        % however
      end
      timestamp('jri_printmulti_noclobber')
      if fbase(1) ~= filesep,

        fname = [fbase '_' sprintf('%02.0f',figNo) '_' tstamp '.' extension];
        fname = fullfile_mkdir(figpath, dstamp,fname);
      else
        fname = [fbase '_' sprintf('%02.0f',figNo) '_' tstamp '.' extension];
        directory = fileparts(fname);
        fullfile_mkdir(directory,''); %ensure the directory exists
      end
      disp(['Exporting Fig. ' num2str(figNo) ' to ' fname])

      print(fig,['-d' type], resStr, fname)
   end
   
end

if ~noshow,
  %as convenience, open finder to exported figs' directory
  directory = fileparts(fname);
  c=computer;
  if strcmp(c(1:2),'MA'),
      cmd = ['open ''' directory ''''];
  else
      cmd = ['gnome-open ''' directory ''''];
  end
  unix(cmd);
end
