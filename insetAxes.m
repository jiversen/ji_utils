function hout = insetAxes(varargin)
% insetAxes  Flexible creation of inset plots. Corner or data-anchored, auto-inferred.
%
%   insetAxes                           % default: corner @ 'ul', size=1/3 of host minor side
%   insetAxes('source', axh, ...)       % copy contents of existing axis into inset
%
%   MODE INFERENCE
%     - If 'location' is a char ('ul','ur','ll','lr','uc','lc')  → corner mode
%     - If 'location' is a numeric [x y] (data coordinates)       → data-anchored mode
%
%   SHARED PARAMETERS (work in both modes)
%     'host'       axis handle to host axis (default: gca)
%     'source'     axis handle to copy (default: [] → create empty axes)
%     'location'   char corner OR numeric [x y] in host data coords (default: 'ul')
%     'size'       fraction of host axis **smaller** side (default: 1/3)
%     'layer'      'over'|'under' (default: 'over'); 'under' sets host Color='none'
%     'delete'     flag; delete existing insets (tag='jri_insetAxes') first
%
%   OPTIONALS (both modes)
%     'padding'    multiplier on box size (default: 1.0; e.g., 1.15 for a small margin)
%     'lockaspect' true/false → pbaspect([1 1 1]) and axis([-1.1 1.1 -1.1 1.1]) (default true)
%     'edgecolor'  inset axes edge color or 'none' (default 'none')
%     'facecolor'  inset axes background (default 'none')
%     'relayout'   true/false → keep data-anchored inset glued on figure resize (default true)
%
%   Returns: handle to the new inset axes.
%
%   Notes:
%     - Depends on scaleAxis.m, getparam.m, isparam.m
%
%   Original Author: John Iversen, 2006
%   Upgrade (auto-mode + data anchor using size): 2025

% ---------- Params ----------
hostaxis  = getparam('host',     varargin, 1, gca);
srcaxis   = getparam('source',   varargin, 1);
location  = getparam('location', varargin, 1, 'ul');   % char corner OR [x y]
sz        = getparam('size',     varargin, 1, 1/3);
layer     = getparam('layer',    varargin, 1, 'over');
doDelete  = isparam('delete',    varargin);

padding   = getparam('padding',  varargin, 1, 1.0);
lockasp   = getparam('lockaspect',varargin,1, true);
edgecol   = getparam('edgecolor', varargin,1, 'none');
facecol   = getparam('facecolor', varargin,1, 'none');
doRelayout= getparam('relayout',  varargin,1, true);

if doDelete
    delete(findobj(gcf,'tag','jri_insetAxes'));
end

destaxis = hostaxis;
parHandle = destaxis.Parent;

% ---------- Create/copy inset axes ----------
if ~isempty(srcaxis)
    newax = copyobj(srcaxis, parHandle);
    axes(newax);
else
    newax = axes('Parent', parHandle);
    axes(newax);
end

set(newax, 'tag','jri_insetAxes', 'Units','normalized', 'Color', facecol, ...
           'Box','on', 'XColor', edgecol, 'YColor', edgecol);

% ---------- Host geometry (pixels + minor side) ----------
[hostPosPx, parPosPx] = axisAndParentPixels(destaxis);
hostMinorPx = min(hostPosPx(3:4));              % smaller of width/height in pixels
boxPx       = max(1, padding * sz * hostMinorPx); % square box side in pixels

% ---------- Mode inference ----------
if isnumeric(location) && numel(location)==2 && all(isfinite(location))
    mode = 'data';
    x0 = location(1); y0 = location(2);
elseif ischar(location) || (isstring(location) && isscalar(location))
    mode = 'corner';
    location = lower(char(location));
    if ~ismember(location, {'ul','ur','ll','lr','uc','lc'})
        error('JRI:insetAxes:incorrectLocation', ...
              'location must be ''ul'',''ur'',''ll'',''lr'',''uc'',''lc'', or numeric [x y].');
    end
else
    error('JRI:insetAxes:badLocation', ...
          'location must be a corner code (char) or data coordinates [x y].');
end

% ---------- Compute normalized Position for inset ----------
switch mode
    case 'corner'
        pos = cornerPosition(destaxis, hostPosPx, parPosPx, location, boxPx);
    case 'data'
        pos = dataAnchoredPosition(destaxis, hostPosPx, parPosPx, x0, y0, boxPx);
end
set(newax, 'Position', pos);

% ---------- Typography/line scaling (use your scaleAxis) ----------
if ~isempty(srcaxis)
    % === SOURCE CASE: scale *once* with scaleAxis, then set Position ===
    s = scaleToBox_fromSource(srcaxis, destaxis, boxPx);  % compute s (see below)
    axes(newax);
    scaleAxis([s s]);   % shrinks geometry + styles proportionally
    set(newax, 'Position', pos);  % restore original position (ignore scaleAxis own scaling of location)
else
    % === EMPTY CASE: no geometric scaling; set style defaults only ===
    styleInsetDefaultsFromHost(newax, destaxis, boxPx);
end

% ---------- Aspect lock / ticks (nice for RP glyphs) ----------
if lockasp
    pbaspect(newax,[1 1 1]);
    axis(newax, [-1.1 1.1 -1.1 1.1]);
    %newax.Visible = 'off';
end

% ---------- Layer handling ----------
if strcmpi(layer,'under')
    set(destaxis,'Color','none');
end

% ---------- Optional: keep data-anchored insets glued on resize ----------
if doRelayout && strcmp(mode,'data')
    setappdata(newax, 'jri_inset_anchor_autosize', struct( ...
        'host', destaxis, 'x0', x0, 'y0', y0, 'sizeFrac', sz, 'padding', padding, ...
        'lockasp', lockasp, 'edgecol', edgecol, 'facecol', facecol));
    fig = ancestor(destaxis,'figure');
    prevFcn = fig.SizeChangedFcn;
    fig.SizeChangedFcn = @(src,evt) jri_relayout_autosize(src,evt, prevFcn);
end

if nargout, hout = newax; end
end

% ===== Helpers =====

function [axPx, parPx] = axisAndParentPixels(ax)
    oldU = ax.Units; ax.Units = 'pixels'; axPx = ax.Position; ax.Units = oldU;
    par = ax.Parent; oldUp = par.Units; par.Units = 'pixels'; parPx = par.Position; par.Units = oldUp;
end

function pos = cornerPosition(axHost, axPx, parPx, location, boxPx)
    % Padding consistent with your original (small inner margins)
    inset = 0.05;
    destleft  = axPx(1) + 2*inset*axPx(3);
    destright = axPx(1) + (1-inset)*axPx(3);
    destbot   = axPx(2) + 2*inset*axPx(4);
    desttop   = axPx(2) + (1-inset)*axPx(4);

    w = boxPx; h = boxPx;
    switch location(1)
        case 'u', yo = desttop - h;
        case 'l', yo = destbot;
        otherwise, yo = desttop - h;
    end
    switch location(2)
        case 'l', xo = destleft;
        case 'r', xo = destright - w;
        case 'c', xo = destright - (destright - destleft)/2 - w/2;
        otherwise, xo = destleft;
    end

    pos = [xo/parPx(3), yo/parPx(4), w/parPx(3), h/parPx(4)];
end

function pos = dataAnchoredPosition(axHost, axPx, parPx, x0, y0, boxPx)
    xl = xlim(axHost); yl = ylim(axHost);
    sx = axPx(3)/diff(xl); sy = axPx(4)/diff(yl);   % pixels per data unit
    cx = axPx(1) + (x0 - xl(1))*sx;                 % center in parent pixels
    cy = axPx(2) + (y0 - yl(1))*sy;
    half = boxPx/2;
    left   = (cx - half)/parPx(3);
    bottom = (cy - half)/parPx(4);
    width  = boxPx/parPx(3);
    height = boxPx/parPx(4);
    pos = [left bottom width height];
end

function applyScaleAxisForBox_HostRel(axInset, hostMinorPx, sizeFrac, padding)
% hostMinorPx = min(host.widthPx, host.heightPx)
% boxPx = padding * sizeFrac * hostMinorPx
    if nargin < 4 || isempty(padding), padding = 1.0; end
    boxPx = padding * sizeFrac * hostMinorPx;
    % Choose a baseline where scale=1 when inset occupies, say, 1/3 of host minor.
    baselineFrac = 1/3;   % matches your legacy default
    s = max(0.05, (sizeFrac / baselineFrac));
    axes(axInset);
    scaleAxis([s s]);
end

function s = scaleToBox_fromSource(srcaxis, hostAxis, boxPx)
% Scale factor so that the *minor* side of the copied source matches boxPx.
    % Source minor in pixels
    oldU = srcaxis.Units; srcaxis.Units = 'pixels';
    sp = srcaxis.Position; srcaxis.Units = oldU;
    srcMinorPx = min(sp(3:4));
    % Guard against degenerate source; fall back to host minor
    if srcMinorPx <= 1
        oldU = hostAxis.Units; hostAxis.Units = 'pixels';
        hp = hostAxis.Position; hostAxis.Units = oldU;
        srcMinorPx = min(hp(3:4))/3;  % reasonable fallback baseline
    end
    s = max(0.01, boxPx / srcMinorPx);
end

function styleInsetDefaultsFromHost(axInset, hostAxis, boxPx)
% Set *defaults only* (fonts/linewidths) so future drawings inherit scaled styles.
% No geometry changes—keeps the inset at Position you just set.
    % Derive a scale from host text size and a nominal baseline
    baseFS = get(hostAxis, 'FontSize');
    baseLW = get(hostAxis, 'LineWidth');

    % Pick a baseline minor for "normal" look (tune once)
    refMinorPx = 400;
    s = max(0.05, boxPx / refMinorPx);

    minFS = 6;
    minLW = 0.2;
    fs = max(minFS, baseFS * s);
    lw = max(minLW, baseLW * s);

    set(axInset, 'FontSize', fs, 'LineWidth', lw);
end

function jri_relayout_autosize(fig, evt, prevFcn)
if ~isempty(prevFcn), try, prevFcn(fig, evt); end %#ok<TRYNC>
    axList = findobj(fig, 'Type','axes', 'Tag','jri_insetAxes');
    for k = 1:numel(axList)
        axInset = axList(k);
        cfg = getappdata(axInset, 'jri_inset_anchor_autosize');
        if isempty(cfg) || ~isgraphics(cfg.host), continue; end

        [axPx, parPx] = axisAndParentPixels(cfg.host);
        hostMinorPx   = min(axPx(3:4));
        boxPx         = max(1, cfg.padding * cfg.sizeFrac * hostMinorPx);
        pos = dataAnchoredPosition(cfg.host, axPx, parPx, cfg.x0, cfg.y0, boxPx);
        set(axInset, 'Position', pos);

        if cfg.lockasp
            pbaspect(axInset,[1 1 1]);
            axis(axInset, [-1.1 1.1 -1.1 1.1]);
        end
        % Re-apply scaling for fonts/linewidths to match the new pixel size
        %applyScaleAxisForBox(axInset, boxPx);
    end
end
end