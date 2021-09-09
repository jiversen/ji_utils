function strout = simplestat(a,b,alphain,center,labels, title)
% simplestat display a variety of summary statistics and tests
%
% simplestat(a,b,alphain,center,labels, title)
%
%   ignores nans
%
% smplestat(data,group,alphain,center) %use data grouped by groupingvariable group (cell or char)
%                                      %since this is bivariate, take only first two groups

warnstate = warning('off','stats:jbtest:OutOfRangeP');

alpha = 0.05;
center = 0;

if nargin > 2 && ~isempty(alphain),
    alpha = alphain;
end

if nargin < 4 || isempty(center),
    center = 0;
end
str = '';

if nargin < 5 || isempty(labels),
    labels{1} = 'A';
    labels{2} = 'B';
end

if nargin < 6,
  title = '';
end

%convert from data,group form to a,b form
if nargin > 1 && (ischar(b) || iscell(b)),
  [gidx, glab] = grp2idx(b);
  if length(glab)==1,
    a = a(gidx==1);
    b = [];
    labels = glab(1);
  else
    b = a(gidx==2); %must do first, since next changes a
    a = a(gidx==1);
    labels = glab(1:2);
    if length(glab)>2,
      warning('Taking only first two groups; ignoring the rest')
    end
  end
end


%eliminate NaNs
%   if data are of same length, guess that we care about pairwise analysis
%   eliminate entire row if there's a nan in a or b
% 4/28/14 --but sometimes this guess is incorrect, need a way
%   to specify if goal is pairwise or not... TODO
if false,
  if nargin > 1 && length(a)==length(b),
    nans = isnan(a) | isnan(b);
    a(nans) = [];
    b(nans) = [];
  else
    a(isnan(a)) = [];
    if nargin > 1,
      b(isnan(b)) = [];
    end
  end
end

if nargin == 1 || isempty(b),
    %null hypothesis: normal
    if sum(a)~=0,
        [h, p] = jbtest(a, alpha);
    else
        h = 0;
        p = 0;
    end
    isNormal = ~h;
    str = sprintf('%sNormalcy:  ',str);
    if isNormal,
        str = sprintf('%s%s may be normal', str, labels{1});
    else
        str = sprintf('%s%s likely NOT normal', str, labels{1});
    end
    str = sprintf('%s, p=%f\n\n',str, p);
    
    %hypothesis tests:
    [h, p, ci, stats] = ttest(a, center, alpha);
    [ps,hs]     = signrank(a);
    if hs, sigStr = '*'; else sigStr = ''; end
    test = 't test';
    sigDiff = h;
    str = sprintf('%st test:  ', str);
    nA = sum(~isnan(a));
    if sigDiff,
        str = sprintf('%s%s (mean=%.3f, n=%d, df=%d) significantly different from %f', ...
            str, labels{1}, nanmean(a),nA,stats.df,center);
    else
        str = sprintf('%s%s (mean=%.3f, n=%d, df=%d) NOT significantly different from %f', ...
            str, labels{1}, nanmean(a),nA,stats.df,center);
    end
    str = sprintf('%s\n\tp=%f, t(%d)=%.2f, CI = [%.3f %.3f], (Wilcoxon signed-rank p=%f%s)\n\n',...
      str,p, stats.df, stats.tstat, ci(1), ci(2),ps,sigStr);
    
else
    %null hypothesis: normal
    if sum(a)~=0,
        [h, p] = jbtest(a, alpha);
    else
        h = 0;
        p = 0;
    end
    AisNormal = ~h;
    str = sprintf('%sNormalcy:  ', str);
    if AisNormal,
        str = sprintf('%s%s is normal', str, labels{1});
    else
        str = sprintf('%s%s is NOT normal', str, labels{1});
    end
    str = sprintf('%s, p=%f\n\n', str,p);
    
    if sum(b)~=0,
        [h, p] = jbtest(b, alpha);
    else
        h = 0;
        p = 0;    
    end
    BisNormal = ~h;
    str = sprintf('%sNormalcy:  ', str);
    if BisNormal,
        str = sprintf('%s%s is normal', str, labels{2});
    else
        str = sprintf('%s%s is NOT normal', str, labels{2});
    end
    str = sprintf('%s, p=%f\n\n', str,p);
    
    AisNormal = 0;
    BisNormal = 0;
    
    %%individual hypothesis tests
    %%  ttest if normal, nonparametric if not
    [h, p, ci,stats]  = ttest(a, center, alpha);
    if isnan(h), h=0; p=1; end
    [ps,hs,statss]    = signrank(a);
    if hs, sigStr = '*'; else sigStr = ''; end
    test = 't test';
    sigDiff = h;
    str = sprintf('%s%s:  ', str, test);
    nA = sum(~isnan(a));
    if sigDiff,
        str = sprintf('%s%s (mean=%.3f, std= %.3f, n=%d, df=%d) significantly different from %g', ...
            str, labels{1}, nanmean(a),nanstd(a),nA,stats.df, center);
    else
        str = sprintf('%s%s (mean=%.3f, std= %.3f, n=%d, df=%d) NOT significantly different from %g', ...
            str, labels{1}, nanmean(a),nanstd(a),nA,stats.df,center);
    end
    str = sprintf('%s\n\tp=%f, t(%d)=%.2f, CI = [%.3f %.3f], (Wilcoxon signed-rank p=%f%s, df=%d)\n\n', ...
      str,p, stats.df, stats.tstat, ci(1), ci(2),ps,sigStr,stats.df);
    
    
    [h, p, ci,stats]  = ttest(b, center, alpha);
    if isnan(h), h=0; p=1; end
    [ps,hs,t]     = signrank(b);
    if hs, sigStr = '*'; else sigStr = ''; end
    test = 't test';
    sigDiff = h;
    if isnan(sigDiff), sigDiff = false; end
    str = sprintf('%s%s:  ', str, test);
    nB = sum(~isnan(b));
    if sigDiff,
        str = sprintf('%s%s (mean=%.3f, std= %.3f, n=%d, df=%d) significantly different from %g', ...
            str, labels{2}, nanmean(b),nanstd(b),nB,stats.df,center);
    else
        str = sprintf('%s%s (mean=%.3f, std= %.3f, n=%d, df=%d) NOT significantly different from %g', ...
            str, labels{2}, nanmean(b),nanstd(b),nB,stats.df,center);
    end
    str = sprintf('%s\n\tp=%f, t(%d)=%.2f, CI = [%.3f %.3f], (Wilcoxon signed-rank p=%f%s, df=%d)\n\n', ...
      str,p, stats.df, stats.tstat, ci(1), ci(2),ps,sigStr,stats.df);
    
    %%two-sample tests tests (unpaired)
    [h, p, ci,stats] = ttest2(a,b, alpha);
    sigDiff = h;
    if isnan(sigDiff), sigDiff = false; end
    str = sprintf('%sunpaired t test:  ', str);
    if sigDiff,
        str = sprintf('%s%s & %s (A-B = %.3f, df=%d) significantly different', ...
            str, labels{1}, labels{2}, nanmean(a)-nanmean(b),stats.df);
    else
        str = sprintf('%s%s & %s (A-B = %.3f, df=%d) NOT significantly different', ...
            str, labels{1}, labels{2}, nanmean(a)-nanmean(b),stats.df);
    end
    str = sprintf('%s\n\tp=%f, t(%d)=%.2f, CI = [%.3f %.3f]\n\n', ...
      str,p, stats.df, stats.tstat, ci(1), ci(2));
    
    str = sprintf('%sNonparametric, Wilcoxon rank sum\n', str);
    [p, h, stats] = ranksum(a(~isnan(a)),b(~isnan(b)),alpha);
    U=stats.ranksum;
    medDiff = h;
    if medDiff,
        str = sprintf('%s%s & %s (A-B = %.3f) medians significantly different', ...
            str, labels{1}, labels{2}, nanmedian(a)-nanmedian(b));
    else
        str = sprintf('%s%s & %s (A-B = %.3f) medians NOT significantly different', ...
            str, labels{1}, labels{2}, nanmedian(a)-nanmedian(b));
    end
    str = sprintf('%s\n\tp=%f, medA = %.3f, medB = %.3f, U=%f\n\n', str,p, nanmedian(a), nanmedian(b), U);
    
    %%add a paired ttest
    if length(a)==length(b),
        d = a-b;
        
        [h, p, ci,stats] = ttest(a,b, alpha);
        if isnan(h), %degenerate case a & b all zeros
            h = 0;
            p = inf;
        end
        meanDiff = nanmean(d);
        sigDiff = h;
        str = sprintf('%spaired t test:  ', str);
        if sigDiff,
            str = sprintf('%s%s & %s (mean diff = %.3f) significantly different', ...
                str, labels{1}, labels{2}, meanDiff);
        else
            str = sprintf('%s%s & %s (mean diff = %.3f) NOT significantly different', ...
                str, labels{1}, labels{2}, meanDiff);
        end
        str = sprintf('%s\n\tp=%f, t(%d)=%.2f, CI = [%.3f %.3f], df=%d\n\n', ...
          str,p, stats.df, stats.tstat, ci(1), ci(2),stats.df);
        
        
        %% paired nonparametric
        [p,h,stats] = signrank(d);
        meanDiff = nanmean(d);
        sigDiff = h;
        str = sprintf('%spaired Wilcoxon signed rank:  ', str);
        if sigDiff,
            str = sprintf('%s%s & %s (med diff = %.3f) significantly different', ...
                str, labels{1}, labels{2}, nanmedian(a)-nanmedian(b));
        else
            str = sprintf('%s%s & %s (med diff = %.3f) NOT significantly different', ...
                str, labels{1}, labels{2}, nanmedian(a)-nanmedian(b));
        end
        str = sprintf('%s\n\tp=%f\n\n', str,p);
        
    end
end

str(end) = ''; %remove last \n

if ~nargout,
  disp(' ')
  if ~isempty(title)
    disp(repmat('-',[1 80]))
    disp(title)
    disp(repmat('-',[1 80]))
    disp(' ')
  end
  disp(str)
  disp(repmat('-',[1 80]))
else
  strout = str;
end

warning(warnstate)
