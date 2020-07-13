classdef timingData
    %timingData holds all the time data for each cell

    properties
        %chip timing data names
        chipGate_data = {'Front Delay','Drop Time','Rise Time','Back Delay','Pulse Duration','Gate Off'};
        chipIn_data = {'Front Delay','Rise Time','Steady State','Drop Time','Back Delay','Pulse Duration'};
        chipOut_data = {'Propagation Delay','Change Time'};
        chipTrig_data = {'Setup Time','Hold Time', 'Pulse Width'};

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
