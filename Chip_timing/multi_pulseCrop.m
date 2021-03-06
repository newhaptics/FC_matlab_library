function [pulseDf, pulseBright, fallEdge, riseEdge] = multi_pulseCrop(avgBright,df,name,S,E)
% pulseData takes in the avgBright and df data and crops it to fit within
% also returns the amount cropped off at the beginning
% the pulse of the arduino leds

index = findIndex(name,'gateLed');

%get the real derivative 
df = diff(avgBright);
%delete last element of avgBright so they are same length
avgBright(end,:) = [];

%get times of gate change
gate_change = abs(df(:,index)) > 0.2 * max(abs(df(:,index)));
gate_change = find(gate_change == 1);


%get number of pulses
numPulses = length(gate_change)/2;

%find the pulse for the element
Epulse = mod(E - 1,numPulses) + 1;

%grab that pulse
gate_change = [gate_change(Epulse*2 - 1) gate_change(Epulse*2)];

%seperate into start change and end change
s = (gate_change(end) - gate_change(1))/2 + gate_change(1);


%get rising and falling edge times
fallingEdge = gate_change(gate_change < s);
risingEdge = gate_change(gate_change > s);

%cropped pulse brightness and differential
pulseDf = df(fallingEdge(end):(risingEdge(1)+ s - gate_change(1)) - 1,:);
pulseBright = avgBright(fallingEdge(end):(risingEdge(1)+ s - gate_change(1)) - 1,:);
fallEdge = fallingEdge(end);
riseEdge = ceil((risingEdge(1)+ s - gate_change(1)));

end
