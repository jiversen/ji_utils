function cmap = pastelmap
% Modified Brewer pastel 1 colormap for cell backgrounds
% JRI

cmap = [[251,180,174];[179,205,227];[204,235,197];[222,203,228];[254,217,166];...
  [255,255,204];[229,216,189];[253,218,236];[242,242,242]]/255;

cmaph = rgb2hsv(cmap);
cmaph = [cmaph.*[1 .5 1.05]; cmaph]; %add a faded version to start, followed by original
cmaph = min(cmaph,1); %clamp

%[~,i]= sort(-cmaph(:,1)); %for testing, sort by hue
%cmaph=cmaph(i,:);

cmap = hsv2rgb(cmaph);
cmap(9,:) = cmap(18,:); %fix up the grays
cmap(18,:) = [210 210 210]/255;

% test visualize
%figure; mt = uitable('Data',round(cmap*255), 'BackgroundColor',cmap);
