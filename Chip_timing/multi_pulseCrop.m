function [pulseDf, pulseBright, fallEdge, riseEdge] = multi_pulseCrop(avgBright,df,name,S,E)
% pulseData takes in the avgBright and df data and crops it to fit within
% also returns the amount cropped off at the beginning
% the pulse of the arduino leds

index = findIndex(name,'gateLed');

%get times of gate change
gate_change = abs(df(:,index)) > 0.2 * max(abs(df(:,index)));
gate_change = find(gate_change == 1);

%seperate into start change and end change
s = (gate_change(end) - gate_change(1))/2;


%get rising and falling edge times
fallingEdge = gate_change(gate_change < s);
risingEdge = gate_change(gate_change > s);

%cropped pulse brightness and differential
pulseDf = df(fallingEdge(end):risingEdge(1) - 1,:);
pulseBright = avgBright(fallingEdge(end):risingEdge(1) - 1,:);
fallEdge = fallingEdge(end);
riseEdge = risingEdge(1);

end
