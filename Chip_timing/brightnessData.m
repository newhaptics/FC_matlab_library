classdef brightnessData
    %brightnessData a simple class to store the brightness data in a cell
    %   stores four matrices for the different brightness of a cell video
    
    properties
        %brightness data to detect change of state at areas of interest
        avgBright0;
        df0;
        pulseBright0;
        pulseDf0;
        avgBright1;
        df1;
        pulseBright1;
        pulseDf1;
    end
    
    methods
        function bright = brightnessData(avgbt0,diff0,pBt0,pdiff0,avgbt1,diff1,pBt1,pdiff1)
            %brightData stores the brightness data of a cell
            bright.avgBright0 = avgbt0;
            bright.df0 = diff0;
            bright.pulseBright0 = pBt0;
            bright.pulseDf0 = pdiff0;
            bright.avgBright1 = avgbt1;
            bright.df1 = diff1;
            bright.pulseBright1 = pBt1;
            bright.pulseDf1 = pdiff1;
        end
    end
end

