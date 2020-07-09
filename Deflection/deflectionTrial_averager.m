function [avgDeflection, avgForce, stdDeflection] = deflectionTrial_averager(Trials)
%deflectionTrial_averager finds the averages of all the trials entered

upDeflection = NaN(size(Trials,1),1000);
upForce = NaN(size(Trials,1),1000);
downDeflection = NaN(size(Trials,1),1000);
downForce = NaN(size(Trials,1),1000);

minimumF = 100000;


%truncate the force data read in
for i = 1:size(Trials,1)
    trial = deflectionTrial_grabber(Trials(i,:));
    if max(trial.force) < minimumF
        minimumF = max(trial.force);
    end
    
end


%grab data and interpolate to same length
for i = 1:size(Trials,1)
    trial = deflectionTrial_grabber(Trials(i,:));
    
    
    %find the uprange and downrange
    [uprange, downrange] = turn_around([trial.force' trial.deflection']);
    
    
    %interpolate data then truncate
    upf = linspace(trial.force(uprange(1)),trial.force(uprange(end)),1000);
    upd = interp1(trial.force(uprange(1):uprange(end)),trial.deflection(uprange(1):uprange(end)),upf);
    
    downf = linspace(trial.force(downrange(1)),minimumF,1000);
    downd = interp1(trial.force(downrange(1):downrange(end)),trial.deflection(downrange(1):downrange(end)),downf);
    
    upForce(i,:) = upf;
    upDeflection(i,:) = upd;
    downForce(i,:) = downf;
    downDeflection(i,:) = downd;
    
    
    
    
end

%find the average and std dev
avgForce = [mean(upForce); mean(downForce)];
avgDeflection = [mean(upDeflection); mean(downDeflection)];
stdDeflection = [std(upDeflection); std(downDeflection)];

end

