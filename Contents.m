% JI_UTILS  A collection of personal matlab utility functions written over
%               the years (2001-present).
%
%   https://github.com/jiversen/ji_utils
% 
% The ones that I find myself using most often and unable to live without are jisubplot/nextplot,
% gridx/gridy/patchx, jisuptitle, jicolorbar, nudgeAxis, insetAxis, hideAxisLabels, timestamp, the colormaps, orthoMontage, 
% parameter, structure and string utilities, hilbert analysis, jnearest.  May you find something useful here.
%
% JRI 7/22
%
% FIGURES
%
%   blockclose              - blockclose  prevent a figure from being closed by the 'close' command
%   combineFigs             - combineFigs  Combine a set of figure windows into a single figure
%   expmulti                - expmulti  Export all plots prepared with jisubplot/nextplot.
%   ff                      - flipfig (ff)   flip through a set of figures
%   numScreens              - numScreens  return the number of displays attached to this computer
%   orthoMontage            - orthoMontage  make an orthogonal montage of a 3-d figure
%
%  jisubplot suite (see file exchange; predates tiledlayout by 15 years and
%       offers a few additional benefits including figure sizing, tiling by
%       row or column, skipping and printing axis labels only at endges of
%       figure...
%
%   currentplotis           - currentplotis  Test if current plot pane is at a special location (e.g. row end, etc)
%   jisubplot               - Set up a figure for multi-pane plotting. Used with NEXTPLOT.
%   nextplot                - Advance to next plotting pane in figure set up with JISUBPLOT.
%
%  see also: freezecolors to allow multiple colormaps on a figure or axis (https://github.com/jiversen/freezeColors)
%
% PLOT TYPES
%
%   baroutline              - baroutline  Draw outline of a bar plot (useful for histograms) 
%   histoutline             - histoutline  Draw histogram outline
%   jierrorbar              - Error bar plot. Fixed ERRORBAR to enable proper legends (JRI 12/01)
%   jihist                  - jihist    more powerful histogram analysis/plotting
%.  jplot3                  - convenience version of plot3
%   plotDashedError         - plotDashedError  Plot curve with error range dashed above and below
%   plotDisjoint            - plotDisjoint  Plot disjoint segments of a curve
%   plotMeanMarker          - plotMeanMarker  show triangular marker marking the mean
%   plotShadedError         - plotShadedError  Plot curve with error range shaded underneath
%   sidehist                - histoutline  Draw histogram in outline form vertically
%   xyerrorbar              - xyerrorbar plot points with x and y errorbars
%
% PLOT ADORNMENTS AND MODIFICATION
%
%   cbal                    - cbal balance clim of plot (center on 0)
%   gridx                   - gridx  Plot vertical x grid lines
%   gridy                   - gridy  Plot horizontal y grid lines
%   hideAxisLabels          - Hide axis text labels (but not ticks)
%   insetAxes               - insetAxes  Flexible creation of inset plots. Can add an inset version of one axis onto another.
%   jicolorbar              - Same as COLORBAR, but does not resize current axis. (JRI)
%   jisuptitle              - Puts a title above all subplots. Does not resize axes (unlike suptitle).
%   jititle                 - jititle  JRI's version of TITLE with control of font size and location
%   jititlesub              - Add a title and subtitle to current axis
%   jixlabel                - jixlabel  JRI's version of XLABEL with control of fontsize.
%   jiylabel                - jiylabel  JRI's version of YLABEL with control of fontsize.
%   lllabel                 - Put a text label in lower left corner of a plot
%   nudgeAxis               - nudgeAxis Shift axis position
%   patchx                  - patchx   plot shaded patches on plot
%   plotgrid                - plotGrid  Flexible plotting of grid lines
%   timestamp               - Timestamp the current figure.
%   ullabel                 - Put a text label in upper left corner of a plot
%   xbal                    - xbal balance xlim of plot
%   xticklabel              - xticklabel    replacement for setting xticklabels directly, allowing tex strings
%   xyline                  - xyline draw line x=y on current figure
%   ybal                    - ybal balance ylim of plot
%   ylimall                 - ylimall make ylim of all axes in a figure the same
%
% COLORMAPS
%
%   greenred                - Colormap: red thru black thru green, for distinguishing pos & minus
%   hotcold                 - Colormap: hot thru black thru cool blues, nice for distinguishing pos & minus
%   hotwhitecold            - HOTCOLD  Colormap: hot thru black thru cool blues, nice for distinguishing pos & minus
%   pastelmap               - Modified Brewer pastel 1 colormap for GUI cell backgrounds
%   redblue                 - Colormap: blue thru black thru red, for distinguishing pos & minus
%   redgreen                - REDGREEN  Colormap: green thru black thru red, for distinguishing pos & minus
%   redwhiteblue            - Colormap: blue thru white thru red, for distinguishing pos & minus
%   redwhitegreen           - REDWHITEGREEN  Colormap: green thru white thru red, for distinguishing pos & minus
%   revmap                  - revmap    reverse colormap
%
% INTERACTING WITH PLOTS
%
%   dd                      - dd  measure distances on plot
%   pickHarmonics           - pickHarmonics pick a frequency and display harmonics
%
%
% SIGNAL PROCESSING
%
%   calc_fft                - calc_fft  Calculate fft & power spectrum (convenience function)
%   clamp                   - clamp clamp to limits
%   findwin                 - findwin  special case of find for getting index of a time vector within a window
%   hilanal                 - hilanal   hilbert transform analysis
%   hilrelphase             - hilrelphase   hilbert relative phase between two signals
%   instfreq                - instfreq  simple instantaneous frequency (rate between peaks or zero crossings)
%   jifindpeaks             - findpeaks  Find time of peaks of a signal
%   jnearest                - jnearest   find index into a collection of element nearest to a point
%   plot_fft                - plot_fft  plot powerspectrum of relevance to frequency tagging
%   plotComparison          - plotComparison(newData,oldData,t, Options...)
%   ppsd                    - ppsd  plot psd
%   relphase                - relphase  find relative phase between two time signals
%   zerocrossing            - zerocrossing  Find zerocrossings of a time signal
%
%
% FUNCTION ARGUMENT PARSING AND HELPERS
%
%   callername              - callername  get name of calling mfile
%   getparam                - getparam  Get values for a parameter in a parameter list
%   isparam                 - isparam  Check parameter list to see if given parameter was specified
%   isTextOnlyMatlabSession - isTextOnlyMatlabSession  test if this matlab instance can plot or is text only
%
% STRUCTURE UTILITIES
%
%   copyfields              - copyfields copy a set of fields from one structure to another
%   flattenStruct           - flattenStruct flatten structs within struct
%   packstruct              - packstruct packs a set of variables into a structure
%   renamefield             - renamefield rename field within a struct
%   structarrayfun          - structarrayfun apply a function to each field of structure array across elements of struct array
%   unpackstruct            - unpackstruct unpacks a struct, placing new vars with same name as fields in caller's space
%   whoss                   - whoss show memory usage within a struct
%
% STRING UTILITIES
%
%   protect_underscore      - protect_underscore  Allow underscores to display correctly w/ latex processor
%   strmatch_mixed          - strmatch_mixed  Like strmatch, but fixes a shortcoming:
%
%
% WORKING WITH FILES
%
%   backupfile              - backupfile    Make a timestamped backup of any file (in same dir)
%   fvars                   - fvars  return variables contained in a .mat file
%   fwhos                   - fwhos   does whos on a file
%   getdirs                 - getdirs  return only directories within a path, same format as dir
%   fullfile_mkdir          - Build full filename from parts. Ensure all subdirs exist. Mkdir if not.
%   newestFile              - newestFile find newest file matching a template
%   timestamp               - Generate timestamp string for filename.
%   whichdiff               - whichdiff  utility to find diff between different versions of same .m file
%
% DATA I/O
%
%   jireadtable             - jireadtable read a simple table from a text file
%   jiwritetable            - jiwritetable  write tabular data to file
%
%
% STATISTICS
%
%   linefit                 - linefit draw best fit line and show stats
%   sigStr                  - sigStr    generate asterisks & 'p<n' denoting levels of significance
%   simplestat              - simplestat display a variety of summary statistics and tests
%
%
% MISCELLANEOUS
%
%   ageAt                   - ageAt calculate age in years at a target date given the birthdate
%   jwhos                   - jwhos    Replacement for builtin whos--prints size of >3d arrays directly
%   niceround               - niceround Round a number 'up' to the nearest 'nice' one: M x 1eN, M,N int
%   setCommandWindowTitle   - setCommandWindowTitle  customize command window title with hostname and optional string
%   show_progress           - show_progress  Display progress
%   userhome                - userhome  user's home directory
%   username                - username  return current username






