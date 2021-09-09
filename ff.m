function ff(figs)
% flipfig (ff)   flip through a set of figures
%
%   ff(figs)
%       
%       figs, vector of fig numbers. If not specified, use all figs
%       can also be a sequence of digits, e.g. ff 456 == ff([4 5 6])
%
%   up/down advance/retreat, q to finish
%
% JRI 


if nargin < 1 || isempty(figs),    
    figs = get(0,'children');
    figs = sort(figs);
end

if ischar(figs),
    figStr = figs;
    figs = [];
    for i=1:length(figStr);
        figs(end+1) = str2num(figStr(i));
    end
end

nFig = length(figs);

idx = 1;
while true
    figure(figs(idx))
    waitforbuttonpress;
    c = double(get(gcf,'currentcharacter'));
    if isempty(c), continue, end
    switch c,
        case 'q'
            break
        case 30,
            idx = idx + 1;
        case 31,
            idx = idx - 1;
    end
    if idx > nFig, idx = 1; end
    if idx < 1, idx = nFig; end
end
