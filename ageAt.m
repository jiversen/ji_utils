function age = ageAt(birthday, date)
% ageAt calculate age in years at a target date given the birthdate
%
%   age = ageAt(birthday, date)
%
%   birthday in mm/yyyy or JAN-05 (legacy) or yyyy-mm-dd
%   date mm/dd/yyyy or yyyy-mm-dd

if isempty(birthday) || isempty(date),
  age = nan;
  return
end

%check that birthday is m/y
if ~(sum(birthday=='/') == 1 || sum(birthday=='-') == 1 || sum(birthday=='-') == 2), ...
        warning('incorrect birthday format (need mm/yyyy)'), age=nan; return, end
if ~(sum(date=='/')==2 || sum(date=='-')==2), ...
        warning('incorrect date format (need mm/dd/yyyy or yyyy-mm-dd)'), age=nan; return, end


%we have only m/y for birthdate, assume on 15th day
if sum(birthday=='-') == 1,
  tmp = datevec(datenum(birthday,'mmm-yy'));
elseif sum(birthday=='/') == 1,
  a = datenum(birthday,'mm/yyyy');
  tmp = datevec(a);
%  tmp = datevec(datenum(birthday,'mm/yyyy'));
else
    tmp = datevec(datenum(birthday));
end
tmp(3) = 15;
birthday = datestr(datenum(tmp),'mm/dd/yyyy');

% birthday = datestr(datenum(tmp),'mm/dd/yyyy',1950);


%difference in days
diff = DateDiff(birthday, date);

%convert to years (approximate, but since birthday is so coarse, no worry)
age = diff / 365.25;
