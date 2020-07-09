classdef deflection_statistics
    %Class to hold the bubble deflection data for a certain thickness
    %   holds all diameter and pressure data for a specific thickness
    
    properties
        %Thickness of bubble film
        Thickness;
        
        %Diameter tests
        Diameters;
        
        %Pressure tests
        Pressures;
        
        %Trials for force displacement tests
        Trials;
        
        
    end
    
    methods
        
        function Deflector = deflection_statistics(Thick)
            %create new deflection testing chip
            Deflector.Thickness = Thick;
            Deflector.Diameters = {};
            Deflector.Pressures = {};
            Deflector.Trials = [];

        end
        
        function add_trial(Deflector,Filename)
            %grab pressure and diameter from trial
           
            %extract input and add one for correct indexing
            D = str2double(extractBetween(filename,"d","-"));
            
            P = str2double(extractBetween(filename,"p","-"));
            
            %get the correct index for the trial
            Dindex = findindex(Deflector.Diameter,D);
            Pindex = findindex(Deflector.Pressure,P);
            if isempty(Dindex)
                %add the diameter to the list
                Deflector.Diameter = [Deflector.Diameter D];
                Dindex = findindex(Deflector.Diameter,D);
            end
            if isempty(Pindex)
                %add the pressure to the list
                Deflector.Pressure = [Deflector.Pressure P];
                Pindex = findindex(Deflector.Pressure,P);
            end
            
            
            %read in and generate trial data
            data  = dlmread(Filename,'\t',1,1);
            
            
            %create a Trial
            test = deflectionTrial(data);
            
            Deflector.Trials(Dindex,Pindex) = test;
            
            
        end
        
    end
end

