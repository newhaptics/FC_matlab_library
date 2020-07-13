function plotData(avgBright,df,name,header)

fig1 = figure('NumberTitle', 'off', 'Name', header);
clf(fig1);
outputs = length(avgBright(1,:));
subplot(outputs, 1, 1);
title(header);
t = 0:length(avgBright(:,1)) - 1;
for k = 1:outputs
    subplot(outputs, 1, k);
    hold on;
    t = 0:length(avgBright(:,1)) - 1;
    plot(t, avgBright(:,k),'r','LineWidth',1.5);
    plot(t,abs(df(:,k)),'b-');
    set(gca,'fontsize', 16);
    grid on
    ylabel(name(k));
    ylim([0 1]);
    if  k~=outputs
        set(gca,'XTick',[]);
    end
    hold off;
    if k==outputs
        xlabel('Time (s)');
    end
end

end
