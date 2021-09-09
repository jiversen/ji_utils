function SS = structarrayfun(fun, S)
% structarrayfun apply a function to each field of structure array across elements of struct array
%
%   SS = structarrayfun(fun, S)
%
%   e.g. S(1).field = 1; S(2).field = 2; s(3).field = 3;
%
%   structurearrayfun(@mean, S) will return a scalar structure in which .field is mean of [S.field]
%     if S(1).field is scalar, and returns mean of cat(1,S.field) if S(1).field is a row
%   NB. up to you to make sure it does what you want!
%
%   only works on numeric fields (for now), ignores others

for fn = fieldnames(S)',
  
  if isrow(S(1).(fn{1})),
    vec = cat(1,S.(fn{1}));
  elseif numel(S(1).(fn{1}))==1    
    vec = [S.(fn{1})];
  else
    error('field %s must contain scalar or row.',fn{1})
  end
  
  switch class(vec),
    
    case 'double',
      SS.(fn{1}) = fun(vec);
      
    case 'char',
      %ignore, or return empty placeholder?
  end
  
end