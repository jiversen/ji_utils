function Sf = flattenStruct(S,prefix)
% flattenStruct flatten structs within struct
%
% e.g. S.scalar
%      S.struct.scalar
%      S.struct.scalar2
%
% becomes
%      S.scalar
%      S.struct_scalar
%      S.struct_scalar2
%
% also handles 1-d struct arrays

if nargin<2,
  prefix = '';
end

if ~isempty(prefix),
  prefix = [prefix '_'];
end

Sf = struct;

nElem = length(S); 

for iE = 1:nElem,
  
  for fn = fieldnames(S)',
    if ~isstruct(S(iE).(fn{1})),
      Sf(iE).([prefix fn{1}]) = S(iE).(fn{1});
    else
      tmp = flattenStruct(S(iE).(fn{1}),[prefix fn{1}]);
      %uglynes to enable us to cat like this
      % https://www.mathworks.com/matlabcentral/newsreader/view_thread/239866
      newfields = setdiff(fieldnames(tmp), fieldnames(Sf(iE)));
      %reorder according to original order
      [~,sidx] = match_str(fieldnames(tmp),newfields);
      newfields = newfields(sidx);
      %add placeholders
      for nfn = newfields(:)',
        Sf(iE).(nfn{1}) = [];
      end
      %finally, copy
      Sf(iE) = copyfields(tmp,Sf(iE));
    end
  end
  
end