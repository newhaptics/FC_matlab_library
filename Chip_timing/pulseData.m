function [chipGate_vec, chipIn_vec, chipOut_vec, chipTrig_vec] = pulseData(pulseBright,name, chipGate_data, chipIn_data, chipOut_data, chipTrig_data, in)
% pulseData takes in the avgBright and names of the measurements
% and returns the timing vectors


%get the difference vector for pulseBright
pulseBright = pulseBright(20:end-20,:) - min(pulseBright(20:end - 20,:));

%declare vector sizes
chipGate_vec = [1 length(chipGate_data)];
chipOut_vec = [1 length(chipOut_data)];
chipIn_vec = [1 length(chipIn_data)];
chipTrig_vec = [1 length(chipTrig_data)];


%% chipGate timing data

%find delay from gate led to real gate on both ends
index = findIndex(name,'chipGate');

[pulseGate, pulseGate_bottom] = find_gatePulse(pulseBright,index);

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
chipGate_vec(index) = length(pulseGate_bottom);

%gate 1->0
index = findIndex(chipGate_data, 'Drop Time');
chipGate_vec(index) = pulseGate_bottom(1) - pulseGate(1);

%gate 0->1
index = findIndex(chipGate_data, 'Rise Time');
chipGate_vec(index) = pulseGate(end) - pulseGate_bottom(end);


%% chipIn timing data

%find delay from gate led to real gate on both ends
index = findIndex(name,'chipIn');

%find the gate pulse and the bottom of the gate pulse
[pulseIn, pulseIn_steady] = find_chipIn(pulseBright,index,in);

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
if in == 0
    chipIn_vec(index) = pulseIn_steady(1) - pulseIn(1);
else
    chipIn_vec(index) = pulseIn(end) - pulseIn_steady(end);
end

%input 0->1
index = findIndex(chipIn_data, 'Rise Time');
if in == 0
    chipIn_vec(index) = pulseIn(end) - pulseIn_steady(end);
else
    chipIn_vec(index) = pulseIn_steady(1) - pulseIn(1);
end



%% chipOut timing data

%find delay from gate led to real gate on both ends
index = findIndex(name,'chipOut');

%find the gate pulse and the bottom of the gate pulse
[outPulse] = find_outPulse(pulseBright,index,in);

%delay from led to actual pulse
index = findIndex(chipOut_data, 'Propagation Delay');
chipOut_vec(index) = outPulse(end) - pulseGate(1);

%delay on back end
index = findIndex(chipOut_data, 'Change Time');
chipOut_vec(index) = length(outPulse);

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

%function to find gate edge to edge and bottom
function [pulseGate, pulseGate_bottom] = find_gatePulse(pulseBright,index)

%define the reference 1 and 0 value
gate1_reference = mean(pulseBright(20:end-20,index));
gate0_reference = min(pulseBright(20:end-20,index));

%first find the bottom of the gate and build from there
gateBottom = find(pulseBright(20:end-20,index) == min(pulseBright(20:end-20,index))) + 19;
pulseGate_start = gateBottom;
%build backwards in time first
for i = flip(1:gateBottom)
    if pulseBright(i,index) < 0.7*gate1_reference
        pulseGate_start = i;
    else
        if pulseBright(i,index) < pulseBright(i - 1, index)
            pulseGate_start = i;
        else
            break
        end
    end
end

stop = length(pulseBright) - 20;

pulseGate_end = gateBottom;
%build forwards in time second
for i = gateBottom:stop
    if pulseBright(i,index) < 0.7*gate1_reference
        pulseGate_end = i;
    else
        if pulseBright(i,index) < pulseBright(i + 1, index)
            pulseGate_end = i;
        else
            break
        end
    end
end

%pulseGate is from edge to edge
pulseGate = pulseGate_start:pulseGate_end;


pulseGate_bottom = pulseGate(pulseBright(pulseGate,index) <= (0.1 * max(pulseBright(pulseGate,index))));

end


%function to find chipIn pulse
function [pulseIn, pulseIn_steady] = find_chipIn(pulseBright,index,in)

%define the reference 1 and 0 value
if in == 0
    gate1_reference = mean(pulseBright(20:end-20,index));
    gate0_reference = min(pulseBright(20:end-20,index));
else
    gate1_reference = max(pulseBright(20:end-20,index));
    gate0_reference = mean(pulseBright(20:end-20,index));
end

%first find the bottom of the gate and build from there
if in == 0
    gateSwitch = find(pulseBright(20:end-20,index) == min(pulseBright(20:end-20,index))) + 19;
else
    gateSwitch = find(pulseBright(20:end-20,index) == max(pulseBright(20:end-20,index))) + 19;
end

pulseIn_start = gateSwitch;
%build backwards in time first
for i = flip(1:gateSwitch)
    if in == 0
        A = pulseBright(i,index) < 0.7*gate1_reference;
        B = pulseBright(i,index) < pulseBright(i - 1, index);
    else
        A = pulseBright(i,index) > 3*gate0_reference;
        B = pulseBright(i,index) > pulseBright(i - 1, index);
    end
        
    if A
        pulseIn_start = i;
    else
        if B
            pulseIn_start = i;
        else
            break
        end
    end
end

stop = length(pulseBright) - 20;

pulseIn_end = gateSwitch;
%build forwards in time second
for i = gateSwitch:stop
    if in == 0
        A = pulseBright(i,index) < 0.7*gate1_reference;
        B = pulseBright(i,index) < pulseBright(i + 1, index);
    else
        A = pulseBright(i,index) > 3*gate0_reference;
        B = pulseBright(i,index) > pulseBright(i + 1, index);
    end
    
    if A
        pulseIn_end = i;
    else
        if B
            pulseIn_end = i;
        else
            break
        end
    end
end

%pulseGate is from edge to edge
pulseIn = pulseIn_start:pulseIn_end;

if in == 0 
    pulseIn_steady = pulseIn(pulseBright(pulseIn,index) <= (0.1 * max(pulseBright(pulseIn,index))));
else
    pulseIn_steady = pulseIn(pulseBright(pulseIn,index) >= (0.9 * max(pulseBright(pulseIn,index))));
end
end

%function to find edge of output
function [outPulse] = find_outPulse(pulseBright,index,in)

%define the reference 1 and 0 value
gate1_reference = max(pulseBright(20:end-20,index));
gate0_reference = min(pulseBright(20:end-20,index));

outPulse_start = 0;
outPulse_end = 0;

%find middle value
N = pulseBright(20:end-20,index); 
V = max(pulseBright(20:end-20,index)) - mean(pulseBright(20:end-20,index));

[~, closestIndex] = min(abs(N - V.'));
outSwitch = closestIndex + 19;

%build backwards in time first
for i = flip(1:outSwitch)
     if in == 0
       A = pulseBright(i,index) < 0.75*gate1_reference;
       B = pulseBright(i,index) < pulseBright(i - 1, index);
    else
       A = pulseBright(i,index) > 0.25*gate1_reference;
       B = pulseBright(i,index) > pulseBright(i - 1, index);
    end
    
    if A
        outPulse_start = i;
    else
        if B
            outPulse_start = i;
        else
            break
        end
    end
end

for i = outPulse_start:length(pulseBright)
    if in == 0
       A = pulseBright(i,index) > 0.25*gate1_reference;
       B = pulseBright(i,index) > pulseBright(i + 1, index);
    else
       A = pulseBright(i,index) < 0.75*gate1_reference;
       B = pulseBright(i,index) < pulseBright(i + 1, index);
    end
    
    if A
        outPulse_end = i;
    else
        if B
            outPulse_end = i;
        else
            break
        end
    end
end


outPulse = outPulse_start:outPulse_end;


end