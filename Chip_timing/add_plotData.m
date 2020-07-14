function add_plotData(avgBright,df,name,t,fig,cell, color)

figure(fig);
empty = 0;
for k = 1:length(name)
    subplot(length(name), 1, k);
    hold on;
    old_legend = findobj(gcf,'Type', 'legend');
    
    if ~isempty(old_legend) && ~empty
        lString = [old_legend(length(name) + 1 - k).String cell char([cell ' df'])];
    end
        
    plot(t, avgBright(:,k),'-','LineWidth',1.5,'Color', color);
    plot(t,abs(df(:,k)),'-','Color', color);
        
    if ~isempty(old_legend) && ~empty
        legend(lString);
    else
        empty = 1;
        legend(cell, [cell ' df']);
    end
    set(gca,'fontsize', 16);
    grid on
    ylabel(name(k));
    set(get(gca,'YLabel'),'Rotation',360,'HorizontalAlignment','right');
    ylim([0 1]);
    if  k~=length(name)
        set(gca,'XTick',[]);
    end
    hold off;
    
    if k==length(name)
        xlabel('Time (s)');
    end
    legend('hide');
end
x = get(0, 'DefaultFigurePosition');
set(0, 'DefaultFigurePosition', [x(1:2), 800, 600]);
end