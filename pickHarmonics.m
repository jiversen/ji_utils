function pickHarmonics(startFreq, mode)
% harmonics pick a frequency and display harmonics
%
%   pickHarmonics(startFreq, mode)
%
%       mode 'clear' to erase all marks
%       mode [r g b] color to set the color (for multiple scales)

color=[.5 .5 1];

if nargin < 2,
    mode = '';
elseif ~ischar(mode),
        color = mode;
        mode = '';
end

if strcmp(mode,'clear'),
    delete(findobj(gca,'tag','F0_CURSOR'));
    delete(findobj(gca,'tag','F0_TEXT_FIXED'))
    return
end

if nargin < 1,
    %plot fundamental cursor
    xl = xlim;
    xspan = xl(2)-xl(1);
    start_f0 = xl(1)+0.05*xspan;
else
    start_f0 = startFreq;
end

hold on
hcurs = plot(start_f0 * [1 1],ylim,'color',color);
%generate harmonics
nHarm = 10;
fharm = start_f0*[2:nHarm]'; %to 10th harmonic
hharm = plot(fharm * [1 1],ylim,'color',color);
set(hcurs,'ButtonDownFcn',{@cursorCallback, 'down',hcurs,hharm,color}, ...
    'tag', 'F0_CURSOR');
set(hharm,'tag','F0_CURSOR');


function cursorCallback(obj,eventdata,mode, target,hharm,color)

switch mode
    case 'down'
        ax = get(obj,'parent');
        fig = get(ax,'parent');
        set(fig,'WindowButtonUpFcn',{@cursorCallback, 'up', obj,hharm,color})
        set(fig,'WindowButtonMotionFcn',{@cursorCallback, 'track', obj,hharm,color})
        set(obj,'color',[.5 .5 .5])
        set(hharm,'color',[.5 .5 .5])
        set(fig,'Interruptible','off')
        
    case 'up'
        set(target,'color',color);
        set(hharm,'color',color);drawnow
        ax = get(target,'parent');
        fig = get(ax,'parent');
        set(fig,'WindowButtonUpFcn',[])
        set(fig,'WindowButtonMotionFcn',[])
        set(fig,'Interruptible','on')
        f = get(target,'xdata');
        str = sprintf(' F0 = %s\n per = %s',num2str(f(1),4), num2str(1/f(1),4));
        yl = ylim;
        tx = f(1);
        nTags = length(findobj(gca,'tag','F0_TEXT_FIXED')); 
        ty = yl(2)-0.13*(nTags)*(yl(2)-yl(1));
        delete(findobj(gca, 'tag','F0_TEXT_TRACKING'));
        text(tx,ty,str,'fontsize',9,'color',color,'tag','F0_TEXT_FIXED')

    case 'track'
        
        ax = get(target,'parent');
        fig = get(ax,'parent');
        point = get(ax,'currentpoint');
        f = point(1,1);
        set(target,'xdata',[f f])
        for i = 1:length(hharm),
            set(hharm(i), 'xdata', f*(i+1)*[1 1]);
        end
        str = sprintf(' F0 = %s\n per = %s',num2str(f(1),4), num2str(1/f(1),4));
        yl = ylim;
        tx = f;
        %delete our fixed text
        delete(findobj(gca,'tag','F0_TEXT_FIXED','color',color))
        nTags = length(findobj(gca,'tag','F0_TEXT_FIXED')); %# other 
        ty = yl(2)-0.13*(nTags)*(yl(2)-yl(1));
        delete(findobj(gca,'tag','F0_TEXT_TRACKING'));
        text(tx,ty,str,'fontsize',9,'color',color,'tag','F0_TEXT_TRACKING')        
end
