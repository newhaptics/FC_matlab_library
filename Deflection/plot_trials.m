%%ploting thickness side by side
%create one figure with all the diameter data for the psi
T = ['\fontsize{20}' 'displacement tests t200&150 PSI 10 & piezo'];
color = hsv(9);
figure('NumberTitle', 'off', 'Name', T);
hold on;

%for i = 1:size(Trials,1)
%    add_dispTrial(Trials(i,:),color(i,:));
%end


%% 200&150 @any PSI
add_avgTrial(Trials(1:4,:),color(2,:));
add_avgTrial(Trials(5:10,:),color(4,:));

%% 200 @all PSI
% add_avgTrial(Trials(1:4,:),color(2,:));
% add_avgTrial(Trials(5:8,:),color(4,:));
% add_avgTrial(Trials(9:12,:),color(6,:));

%% 150 @all PSI
% add_avgTrial(Trials(1:6,:),color(2,:));
% add_avgTrial(Trials(7:12,:),color(4,:));
% add_avgTrial(Trials(13:18,:),color(6,:));


%% add piezo
% add_avgTrial(Trials(1:5,:),'k');

%%

x = [0 150 150.0001];
y = [0.25 0.25 0];
plot(x,y,'--','color','k');
xlim([0 inf]);
ylim([0 inf]);
xlabel('Force (mN)');
ylabel('Displacement (mm)');
title(T);
set(gcf, 'units', 'normalized', 'position', [0 0 .9 .9]);