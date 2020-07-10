function [pulseDf, pulseBright] = pulseCrop(avgBright,df,name)
% pulseData takes in the avgBright and df data and crops it to fit within
% the pulse of the arduino leds

index = findIndex(name,'gateLed');

%frames of beginning of gate pulse and end
first_frame = find(df(:,index) == min(df(:,index)));
last_frame = find(df(:,index) == max(df(:,index))) + 1;

%get times of gate change
gate_change = abs(df(:,index)) > 0.2 * max(abs(df(:,index)));
gate_change = find(gate_change == 1);

%seperate into start change and end change
s = (gate_change(end) - gate_change(1))/2;


%get rising and falling edge times
fallingEdge = gate_change(gate_change < s);
risingEdge = gate_change(gate_change > s);

%cropped pulse brightness and differential
pulseDf = df(first_frame:end,:);
pulseBright = avgBright(first_frame:end,:);

end

