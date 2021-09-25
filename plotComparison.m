function [h_old,h_new] = plotComparison(olddata,newdata,t,varargin)
% plotComparison(newData,oldData,t, Options...)
% plot comparison between two timeseries (typically before / after some kind of data cleaning)
%  adapted from BCILAB vis_artifacts
%
% Keyboard Shortcuts:
%   [n] : display just the new time series
%   [o] : display just the old time series
%   [b] : display both time series super-imposed
%   [d] : display the difference between both time series
%   [+] : increase signal scale
%   [-] : decrease signal scale
%   [*] : expand time range
%   [/] : reduce time range
%   [h] : show/hide slider
%   [e] : toggle events
%   [l] : toggle event legend
%
% In:
%   newdata     : new data (chan x time)
%   olddata     : original data (chan x time)
%   Options... : name-value pairs specifying the options, with names:
%                'Events' : optional eeglab event structure to show events
%                'YRange' : y range of the figure that is occupied by the signal plot
%                'YScaling' : distance of the channel time series from each other in std. deviations
%                'WindowLength : window length to display
%                'NewColor' : color of the new (i.e., cleaned) data
%                'OldColor' : color of the old (i.e., uncleaned) data
%                'HighpassOldData' : whether to high-pass the old data if not already done
%                'ScaleBy' : the data set according to which the display should be scaled, can be 
%                            'old' or 'new' (default: 'new')
%                'ChannelSubset' : optionally a channel subset to display
%                'TimeSubet' : optionally a time subrange to display
%                'DisplayMode' : what should be displayed: 'both', 'new', 'old', 'diff'
%                'ShowSetname' : whether to display the dataset name in the title
%                'EqualizeChannelScaling' : optionally equalize the channel scaling
%                See also code for more options.
%
% Notes:
%   This function is primarily meant for testing purposes and is not a particularly high-quality
%   implementation.
%
% Examples:
%  vis_artifacts(clean,raw)
%
%  % display only a subset of channels
%  vis_artifacts(clean,raw,'ChannelSubset',1:4:raw.nbchan);
%
%
%                                Christian Kothe, Swartz Center for Computational Neuroscience, UCSD
%                                2010-07-06
%
%                                relies on the findjobj() function by Yair M. Altman.

% Copyright (C) Christian Kothe, SCCN, 2012, christian@sccn.ucsd.edu
%
% This program is free software; you can redistribute it and/or modify it under the terms of the GNU
% General Public License as published by the Free Software Foundation; either version 2 of the
% License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
% even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with this program; if not,
% write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
% USA

have_signallegend = false;
have_eventlegend = false;

if nargin < 2
    olddata = newdata; 
elseif ischar(olddata)
    varargin = [{olddata} varargin];
    olddata = newdata;
end

srate = 1/mean(diff(t));
xmin = min(t);

% parse options
opts = hlp_varargin2struct(varargin, ...
    {'events','Events'},[], ...                 %EEG style event structure
    {'yrange','YRange'}, [0.05 0.95], ...       % y range of the figure occupied by the signal plot
    {'yscaling','YScaling'}, 3.5, ...           % distance of the channel time series from each other in std. deviations
    {'wndlen','WindowLength'}, 10, ...          % window length to display
    {'newcol','NewColor'}, [1 0 0], ...         % color of the new (i.e., cleaned) data
    {'oldcol','OldColor'}, [0 0 0.5], ...       % color of the old (i.e., uncleaned) data
    {'scale_by','ScaleBy'},'new',...            % the data set according to which the display should be scaled
    {'display_mode','DisplayMode'},'both',...   % what should be displayed: 'both', 'new', 'old', 'diff'
    {'show_setname','ShowSetname'},true,...     % whether to display the dataset name in the title
    {'line_spec','LineSpec'},'-',...            % line style for plotting
    {'line_width','LineWidth'},[0.5 1],...          % line width
    {'add_legend','AddLegend'},false,...        % add a signal legend FIXME
    {'show_events','ShowEvents'},false, ...      % whether to show events
    {'show_eventlegend','ShowEventLegend'},false, ...  % whether to show a legend for the currently visible events
    {'equalize_channel_scaling','EqualizeChannelScaling'},true);  % optionally equalize the channel scaling


if isscalar(opts.line_width)
    opts.line_width = [opts.line_width opts.line_width]; end

if opts.equalize_channel_scaling  
    %zero-mean
    mo  = mean(olddata,2);
    olddata = olddata - mo;
    newdata = newdata - mo;
    
    rescale = 1./mad(olddata,[],2);
    newdata = bsxfun(@times,newdata,rescale);
    olddata = bsxfun(@times,olddata,rescale);
end

% generate event colormap
if ~isempty(opts.events)
  opts.event_colormap = gen_colormap(opts.events,'jet');
end

% create a unique name for this visualization and store the options it in the workspace
%taken = evalin('base','whos(''vis_*'')');
%visname = genvarname('vis_artifacts_opts',{taken.name});
visinfo.opts = opts;
%assignin('base',visname,visinfo);


% create figure & slider
lastPos = 0;
hFig = figure; guidata(hFig, visinfo); hold; axis(); set(hFig, 'ResizeFcn',@on_window_resized,'KeyPressFcn',@(varargin)on_key(varargin{2}));
ss = get(0,'ScreenSize');
set(hFig,'position',[ 0.1*ss(3) 0.3*ss(4)  0.8*ss(3) 0.7*ss(4)]);

hAxis = gca;
hSlider = uicontrol('style','slider'); set(hSlider,'KeyPressFcn',@(varargin)on_key(varargin{2})); on_resize();
jSlider = findjobj(hSlider);
jSlider.AdjustmentValueChangedCallback = @on_update;


% do the initial update
on_update();

    function repaint(relPos,moved)
        % repaint the current data
        
        % if this happens, we are maxing out MATLAB's graphics pipeline: let it catch up
        if relPos == lastPos && moved
            return; end
        
        % get potentially updated options
        %visinfo = evalin('base',visname);
        visinfo = guidata(hFig);
                
        % axes
        cla;
        
        % compute pixel range from axis properties
        xl = get(hAxis,'XLim');
        yl = get(hAxis,'YLim');
        fp = get(hFig,'Position');
        ap = get(hAxis,'Position');
        pixels = (fp(3))*(ap(3)-ap(1));
        ylr = yl(1) + opts.yrange*(yl(2)-yl(1));
        channel_y = (ylr(2):(ylr(1)-ylr(2))/(size(newdata,1)-1):ylr(1))';
        
        % compute sample range
        wndsamples = visinfo.opts.wndlen * srate;
        pos = floor((size(newdata,2)-wndsamples)*relPos);
        % while skipping points makes sense for speed, it removes accuracy in examining single sample corrections,
        % so only do it when zoomed out quite a bit. When zoomed in it doubles pixels. Not so cool
        sampPerPixel = wndsamples/pixels;
        if sampPerPixel > 20
          step = sampPerPixel;
        else
          step = 1;
        end
        wndindices = 1 + floor(0:step:(wndsamples-1));
        wndrange = pos+wndindices;
        
        oldwnd = olddata(:,wndrange);
        newwnd = newdata(:,wndrange);
        if strcmp(opts.scale_by,'old')
            iqrange = iqr(oldwnd')';
        else
            iqrange = iqr(newwnd')';
            iqrange(isnan(iqrange)) = iqr(oldwnd(isnan(iqrange),:)')';
        end
        scale = ((ylr(2)-ylr(1))/size(newdata,1)) ./ (visinfo.opts.yscaling*iqrange); scale(~isfinite(scale)) = 0;
        scale(scale>median(scale)*3) = median(scale);
        scale = repmat(scale,1,length(wndindices));
                
        tit = '';
        
        if ~isempty(wndrange)
            tit = [tit sprintf('[%.1f - %.1f]',xmin + (wndrange(1)-1)/srate, xmin + (wndrange(end)-1)/srate)];        
        end
        
        switch visinfo.opts.display_mode            
            case 'both'                
                title([tit '; superposition'],'Interpreter','none');
                h_old = plot(xl(1):(xl(2)-xl(1))/(length(wndindices)-1):xl(2), (repmat(channel_y,1,length(wndindices)) + scale.*oldwnd)','Color',opts.oldcol,'LineWidth',opts.line_width(1));
                h_new = plot(xl(1):(xl(2)-xl(1))/(length(wndindices)-1):xl(2), (repmat(channel_y,1,length(wndindices)) + scale.*newwnd)','Color',opts.newcol,'LineWidth',opts.line_width(2));
          case 'new'
                title([tit '; cleaned'],'Interpreter','none');
                plot(xl(1):(xl(2)-xl(1))/(length(wndindices)-1):xl(2), (repmat(channel_y,1,length(wndindices)) + scale.*newwnd)','Color',opts.newcol,'LineWidth',opts.line_width(2));
            case 'old'
                title([tit '; original'],'Interpreter','none');
                plot(xl(1):(xl(2)-xl(1))/(length(wndindices)-1):xl(2), (repmat(channel_y,1,length(wndindices)) + scale.*oldwnd)','Color',opts.oldcol,'LineWidth',opts.line_width(1));
            case 'diff'
                title([tit '; difference'],'Interpreter','none');
                plot(xl(1):(xl(2)-xl(1))/(length(wndindices)-1):xl(2), (repmat(channel_y,1,length(wndindices)) + scale.*(oldwnd-newwnd))','Color',opts.newcol,'LineWidth',opts.line_width(1));
        end
                
        % also plot events
        if visinfo.opts.show_events && ~isempty(visinfo.opts.events)
            evtlats = [visinfo.opts.events.latency];
            evtindices = find(evtlats>wndrange(1) & evtlats<wndrange(end));
            if ~isempty(evtindices)
                evtpos = xl(1) + (evtlats(evtindices)-wndrange(1))/length(wndrange)*(xl(2)-xl(1));                
                evttypes = {visinfo.opts.events(evtindices).type};
                % for each visible type
                visible_types = unique(evttypes);
                handles = [];
                labels = {};
                for ty = visible_types(:)'
                    % plot line instances in the right color
                    curtype = ty{1};
                    curcolor = visinfo.opts.event_colormap.values(strcmp(visinfo.opts.event_colormap.keys,curtype),:);
                    matchpos = strcmp(evttypes,curtype);
                    h = line([evtpos(matchpos);evtpos(matchpos)],repmat([0;1],1,nnz(matchpos)),'Color',curcolor);
                    handles(end+1) = h(1);
                    labels{end+1} = curtype;
                end
                if visinfo.opts.show_eventlegend
                    legend(handles,labels,'Location','NorthWest'); 
                    have_eventlegend = true;
                elseif have_eventlegend
                    legend off;
                    have_eventlegend = false;
                end
            end
        end        
        axis([0 1 0 1]);
        
        if opts.add_legend && ~have_signallegend
            legend([h_old(1);h_new(1)],'Original','Corrected');
            have_signallegend = 1;
        end
        drawnow;


        lastPos = relPos;
    end


    function on_update(varargin)
        % slider moved
        repaint(get(hSlider,'Value'),~isempty(varargin));
    end

    function on_resize(varargin)
        % adapt/set the slider's size
        wPos = get(hFig,'Position');
        if ~isempty(hSlider)
            try
                set(hSlider,'Position',[20,20,wPos(3)-40,20]);
            catch,end
            on_update;
        end
    end

    function on_window_resized(varargin)
        % window resized
        on_resize();
    end

    function on_key(eventData)
        visinfo = evalin('base',visname);
        key = eventData.Character;
        switch lower(key)
            case {'add','+'}
                % decrease datascale
                visinfo.opts.yscaling = visinfo.opts.yscaling*0.9;
            case {'subtract','-'}
                % increase datascale
                visinfo.opts.yscaling = visinfo.opts.yscaling*1.1;
            case {'multiply','*'}
                % increase timerange
                visinfo.opts.wndlen = visinfo.opts.wndlen*1.1;                
            case {'divide','/'}
                % decrease timerange
                visinfo.opts.wndlen = visinfo.opts.wndlen*0.9;                
            case {'pagedown','uparrow',char(30)}
                % shift display page offset down
                visinfo.opts.pageoffset = visinfo.opts.pageoffset+1;                
            case {'pageup','downarrow',char(31)}
                % shift display page offset up
                visinfo.opts.pageoffset = visinfo.opts.pageoffset-1;
            case 'n'
                visinfo.opts.display_mode = 'new';
            case 'o'
                visinfo.opts.display_mode = 'old';
            case 'b'
                visinfo.opts.display_mode = 'both';
            case 'd'
                visinfo.opts.display_mode = 'diff';
            case 'l'
                visinfo.opts.show_eventlegend = ~visinfo.opts.show_eventlegend;
            case 'e'
                visinfo.opts.show_events = ~visinfo.opts.show_events;
            case 'h'
                if strcmp(get(hSlider,'Visible'),'on')
                    set(hSlider,'Visible','off')
                else
                    set(hSlider,'Visible','on')
                end
        end        
        %assignin('base',visname,visinfo);
        guidata(hFig, visinfo);
        on_update();
    end
end

% create a mapping from event types onto colors
function map = gen_colormap(eventstruct,mapname)
map.keys = unique({eventstruct.type});
if ~isempty(map.keys)
    tmp = colormap(mapname);
    map.values = tmp(1+floor((0:length(map.keys)-1)/(length(map.keys)-1)*(length(tmp)-1)),:);
else
    map.values = [];
end
end
