function [pstr, stars] = sigStr(p)
% sigStr    generate asterisks & 'p<n' denoting levels of significance
%
%   [pstr, stars] = sigStr(p)
%

if nargin==0,
  eval(['help ' mfilename])
  return
end



if p<=0.0001,
    stars = '****';
    pstr = 'p<0.0001';
elseif p<=0.001,
    stars = '***';
    pstr = 'p<0.001';
elseif p<=0.01,
    stars = '**';
    pstr = 'p<0.01';
elseif p<=0.05,
    stars = '*';
    pstr = 'p<0.05';
else
    stars = '';
    pstr = 'n.s.';
end