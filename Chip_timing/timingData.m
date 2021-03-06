classdef timingData
    %timingData holds all the time data for each cell

    properties
        %chip timing data names
        chipGate_data = {'Gate Front Delay','Gate Drop Time','Gate Rise Time','Gate Back Delay','Gate Pulse Width','Gate Off'};
        chipIn_data = {'Input Front Delay','Input Rise Time','Input Steady State','Input Drop Time','Input Back Delay','Input Pulse Width'};
        chipOut_data = {'Propagation Delay','Bubble Inflation Time'};
        chipTrig_data = {'Fluidic Setup Time','Fluidic Hold Time', 'Fluidic Pulse Width', 'Electronic Setup Time', 'Electronic Hold Time', 'Electronic Pulse Width'};

        %chip timing matrices
        chipGate_times;
        chipIn_times;
        chipOut_times;
        chipTrig_times;
    end

    methods

        function time = timingData(gateMat,inMat,outMat,trigMat)
            %timingData stores the timing data of a cell
            time.chipGate_times = gateMat;
            time.chipIn_times = inMat;
            time.chipOut_times = outMat;
            time.chipTrig_times = trigMat;
        end

    end
end
