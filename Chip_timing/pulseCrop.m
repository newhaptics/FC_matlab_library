function [pulseDf, pulseBright] = pulseCrop(avgBright,df,name)
% pulseData takes in the avgBright and df data and crops it to fit within
% the pulse of the arduino leds

index = findIndex(name,'gateLed');

%frames of beginning of gate pulse and end
first_frame = find(df(:,index) == min(df(:,index)));
%last_frame = find(df(:,index) == max(df(:,index))) + 1;

%cropped pulse brightness and differential
pulseDf = df(first_frame:end,:);
pulseBright = avgBright(first_frame:end,:);

end

