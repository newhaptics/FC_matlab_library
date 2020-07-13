function make_heatMap(timingMatrix,timingData,header)
%MAKE_HEATMAP makes multiple heatmaps given timing data
%   creates a subplot with all heatmap data attached
fig1 = figure('NumberTitle', 'off', 'Name', header);
clf(fig1);
numPlots = size(timingData,2);
subplot(ceil(numPlots/3),3,1);
sgtitle(header);
mix1 = summer;
mix2 = autumn;
color = [mix1(129:256,:) ; flip(mix2(129:256,:))];
for k = 1:numPlots
    subplot(ceil(numPlots/3),3,k);
    graphMat = round(timingMatrix(:,:,k));
    h = heatmap(graphMat,'Colormap', color);
    h.Title = [timingData(k) 'heatmap'];
    h.XLabel = 'Chip In';
    h.YLabel = 'Chip Gate';
end

end

