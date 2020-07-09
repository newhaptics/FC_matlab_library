function [uprange, downrange] = turn_around(M)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
toggle = 0;
for j=2:length(M)
        if (M(j,2) < M(j-1,2) && toggle == 0 )
            turnaround=j-1;
            toggle=1;
        end
end
uprange = 1:turnaround;
downrange = turnaround:length(M);
end

