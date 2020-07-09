
classdef deflectionTrial
    %Class to store the trials of the deflection chip
    
    properties
        %Statistics for force displacement and pressure
        deflection;
        
        force;
        
        pressure;
        
    end
    
    methods
        
        function T = deflectionTrial(data)
            %deflection trial statistics
            T.pressure = data(:,3)';
            T.deflection = data(:,2)';
            T.force = data(:,1)';
        end
       
    end
end

