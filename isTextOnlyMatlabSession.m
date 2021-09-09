function bool = isTextOnlyMatlabSession
% isTextOnlyMatlabSession  test if this matlab instance can plot or is text only
%
% JRI 7/26/13

bool = usejava('jvm') && ~usejava('Desktop');