function [avgBright] = add_electronicData(avgBright,name,s,h,pw,frameRate,E,S)
%ADD_ELECTRONICDATA adds the electronic triggers to avgBright


frameRate = frameRate*16;
if isempty(S)
    ledDelay = ceil(0.5*frameRate);
else 
    ledDelay= ceil(0.0005*frameRate);
end

%convert s, h, and pw to frames
s = ceil(s*frameRate);
h = ceil(h*frameRate);
pw = ceil(pw*frameRate);

%find where the Gate signal starts and where the In signal starts
df = diff(avgBright);
if isempty(S)
    [~, ~,fallEdge,~] = pulseCrop(avgBright, df, name);
else
    [~, ~,fallEdge,~] = multi_pulseCrop(avgBright, df, name,S,E);
end
ledLow = fallEdge;
gateStart = ledLow + ledDelay;
inStart = ledLow + ledDelay - s;


%create s, h, and pw vectors
inPulse = zeros(s+h,1);
gatePulse = zeros(pw,1);


%create the electronic Gate signal
index = findIndex(name,'electronicGate');
eGate = ones(length(avgBright),1);
eGate(gateStart:gateStart + length(gatePulse) - 1) = gatePulse;
avgBright(:,index) = eGate;


%create the electronic In signal
index = findIndex(name,'electronicIn');
eIn = ones(length(avgBright),1);
eIn(inStart:inStart + length(inPulse) - 1) = inPulse;
avgBright(:,index) = eIn;



end
