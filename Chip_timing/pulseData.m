function [chipGate_vec, chipIn_vec, chipOut_vec, chipTrig_vec] = pulseData(pulseBright,name, chipGate_data, chipIn_data, chipOut_data, chipTrig_data)
% pulseData takes in the avgBright and names of the measurements
% and returns the timing vectors

%get the difference vector for pulseBright
pulseBright = pulseBright - min(pulseBright);

%declare vector sizes
chipGate_vec = [1 length(chipGate_data)];
chipOut_vec = [1 length(chipOut_data)];
chipIn_vec = [1 length(chipIn_data)];
chipTrig_vec = [1 length(chipTrig_data)];


%% chipGate timing data

%find delay from gate led to real gate on both ends
index = findIndex(name,'chipGate');

%find the gate pulse and the bottom of the gate pulse
pulseGate = find(pulseBright(:,index) <= 0.8*mean(pulseBright(:,index)));
pulseGate_steady = find(pulseBright(:,index) <= 0.2*max(pulseBright(pulseGate,index)));

%delay from led to actual pulse
index = findIndex(chipGate_data, 'Front Delay');
chipGate_vec(index) = pulseGate(1);

%delay on back end
index = findIndex(chipGate_data, 'Back Delay');
chipGate_vec(index) = length(pulseBright) - pulseGate(end);

%duration of pulse
index = findIndex(chipGate_data, 'Pulse Duration');
chipGate_vec(index) = length(pulseGate);

%duration of gate off
index = findIndex(chipGate_data, 'Gate Off');
chipGate_vec(index) = length(pulseGate_steady);

%gate 1->0
index = findIndex(chipGate_data, 'Drop Time');
chipGate_vec(index) = pulseGate_steady(1) - pulseGate(1);

%gate 0->1
index = findIndex(chipGate_data, 'Rise Time');
chipGate_vec(index) = pulseGate(end) - pulseGate_steady(end);


%% chipIn timing data

%find delay from gate led to real gate on both ends
index = findIndex(name,'chipIn');

%find the gate pulse and the bottom of the gate pulse
pulseIn = find(pulseBright(:,index) >= 0.8*mean(pulseBright(:,index)));
pulseIn_steady = find(pulseBright(:,index) >= 0.9*max(pulseBright(pulseIn,index)));

%delay from led to actual pulse
index = findIndex(chipIn_data, 'Front Delay');
chipIn_vec(index) = pulseIn(1);

%delay on back end
index = findIndex(chipIn_data, 'Back Delay');
chipIn_vec(index) = length(pulseBright) - pulseIn(end);

%duration of pulse
index = findIndex(chipIn_data, 'Pulse Duration');
chipIn_vec(index) = length(pulseIn);

%duration of gate off
index = findIndex(chipIn_data, 'Steady State');
chipIn_vec(index) = length(pulseIn_steady);

%input 1->0
index = findIndex(chipIn_data, 'Drop Time');
chipIn_vec(index) = pulseIn_steady(1) - pulseIn(1);

%input 0->1
index = findIndex(chipIn_data, 'Rise Time');
chipIn_vec(index) = pulseIn(end) - pulseIn_steady(end);




%% chipOut timing data

%find delay from gate led to real gate on both ends
index = findIndex(name,'chipOut');

%find the gate pulse and the bottom of the gate pulse
out_pulse = find(pulseBright(:,index) >= 0.5*max(pulseBright(:,index)));

%delay from led to actual pulse
index = findIndex(chipOut_data, 'Internal Propagation');
chipOut_vec(index) = out_pulse(1) - pulseIn(1);

%delay on back end
index = findIndex(chipOut_data, 'Change Time');
chipOut_vec(index) = length(out_pulse);

%% chipTrig timing data

%use information already gathered to calculate times

%verify the setup time
index = findIndex(chipTrig_data, 'Setup Time');
chipTrig_vec(index) = pulseGate(1) - pulseIn(1);


%verified hold time
index = findIndex(chipTrig_data, 'Hold Time');
chipTrig_vec(index) = pulseIn(end) - pulseGate(1);


%verified the pulse width
index = findIndex(chipTrig_data, 'Pulse Width');
chipTrig_vec(index) = pulseGate(end) - pulseGate(1);



end

