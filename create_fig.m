function create_fig(title,xlabel,ylabel)
%create_fig creates figure with name and xy labels to add plot data to
fig1 = figure('NumberTitle', 'off', 'Name', ['\fontsize{20}' title]);
clf(fig1);
hold on;
xlabel(xlabel);
ylabel(ylabel);
title(['\fontsize{20}' title]);
set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
end

