%%ploting thickness side by side
%create color array
PSI = '15';
Diameter = '1.8';
deflector = [deflector50 deflector20];
colors = hsv(size(deflector,2) + 1);

%create one figure with all the diameter data for the psi
fig1 = figure('NumberTitle', 'off', 'Name', ['\fontsize{20}' 'Diameter ' Diameter ' All Thickness PSI ' PSI]);
clf(fig1);
hold on;
for i = 1:size(deflector,2)
    Pindex = findIndex(deflector(i).Pressures,PSI);
    Dindex = findIndex(deflector(i).Diameters,Diameter);
    if ~isempty(deflector(i).Trials(Dindex,Pindex).Stats)
        A = deflector(i).Trials(Dindex,Pindex).Stats(:,1);
        B = deflector(i).Trials(Dindex,Pindex).Stats(:,2);
        scatter(A,B, 36, colors(i,:), 'filled');
        end000
end
legend(split(num2str([deflector.Thickness])));
xlabel('Force (mN)');
ylabel('Displacement (um)');
title(['\fontsize{20}' 'Diameter ' Diameter ' All Thickness PSI ' PSI]);
set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);