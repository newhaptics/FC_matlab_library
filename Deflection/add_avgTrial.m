function add_avgTrial(Trials,color)
%add_avgTrial takes in multiple trials set, averages it and adds it to the existing plot
%with a standard div polygon

%get the average data set
[avgDeflection, avgForce, stdDeflection] = deflectionTrial_averager(Trials);

%create polygon for up and down range
upYbottom = [avgDeflection(1,:) - stdDeflection(1,:)]; 
upYtop = [fliplr(avgDeflection(1,:)) + fliplr(stdDeflection(1,:))];
downYbottom = [avgDeflection(2,:) - stdDeflection(2,:)];
downYtop = [fliplr(avgDeflection(2,:)) + fliplr(stdDeflection(2,:))];


upXbottom = avgForce(1,:);
upXtop = fliplr(avgForce(1,:));
downXbottom = avgForce(2,:);
downXtop = fliplr(avgForce(2,:));


upgon = polyshape([upXbottom upXtop],[upYbottom upYtop]);
downgon = polyshape([downXbottom downXtop], [downYbottom downYtop]);

plot(upgon,'FaceColor',color,'FaceAlpha',0.1);
plot(avgForce(1,:),avgDeflection(1,:),'-','color',color);
plot(avgForce(2,:),avgDeflection(2,:),'--','color',color);
plot(downgon,'FaceColor',color,'FaceAlpha',0.1);

end

