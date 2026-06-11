function S = lfit(X,Y,cfg)
% lfit robust linear fit, return parameters.
%
%   S = lfit(X,Y,cfg)
%
%       if prefix supplied, displays text

if ~isfield(cfg,'color') || isempty(cfg.color)
    cfg.color = [0 0 0];
end
if ~isfield(cfg,'prefix') || isempty(cfg.prefix)
    cfg.prefix='';
end
if ~isfield(cfg,'plot') || isempty(cfg.plot)
    cfg.plot = true;
end

lm = fitlm(X,Y,'RobustOpts','on');
slope = lm.Coefficients.Estimate(2);
pval  = lm.Coefficients.pValue(2);
r2    = lm.Rsquared.Ordinary;

xfit = linspace(min(X), max(X), 100)';
[yfit, yci] = predict(lm, xfit, 'Alpha',0.05);

S.model = lm;
S.slope = slope;
S.pval = pval;
S.r2 = r2;
S.xfit = xfit;
S.yfit = yfit;
S.yci = yci;

if cfg.plot
    fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], ...
        cfg.color, 'FaceAlpha',0.15, 'EdgeColor','none');
    plot(xfit, yfit, '-', 'Color', cfg.color, 'LineWidth', 1.6);

    xText = xfit(end) + 0.05*range(xfit);
    yText = yci(end,1);

    % Text label
    if ~isempty(cfg.prefix)
        txt = sprintf('%s\b\\beta=%.3f\nR²=%.2f\np=%.3f', cfg.prefix, slope, r2, pval);
        text(xText, yText, txt, ...
            'Color', 'k', 'FontSize', 12, ...
            'HorizontalAlignment','left', 'VerticalAlignment','middle', ...
            'FontName','Menlo');   % monospace helps alignment
    end
end
