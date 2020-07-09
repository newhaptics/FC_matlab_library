function make_heatMap(timingMatrix,timingData,header)
%MAKE_HEATMAP makes multiple heatmaps given timing data
%   creates a subplot with all heatmap data attached
fig1 = figure('NumberTitle', 'off', 'Name', header);
clf(fig1);
numPlots = size(timingData,2);
subplot(2,ceil(numPlots/2),1);
sgtitle(header);
for k = 1:numPlots
    subplot(2,ceil(numPlots/2),k);
    h = heatmap(timingMatrix(:,:,k),'Colormap', jet);
    h.Title = [timingData(k) 'heatmap'];
    h.XLabel = 'Chip In';
    h.YLabel = 'Chip Gate';
end

end

