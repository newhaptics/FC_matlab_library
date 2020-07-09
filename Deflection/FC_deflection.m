classdef FC_deflection
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
        
        function Deflector = FC_deflection(Thick)
            %create new deflection testing chip
            Deflector.Thickness = Thick;
            Deflector.Diameters = {};
            Deflector.Pressures = {};
            Deflector.Trials = [];

        end
        
        function Deflector = add_trial(Deflector,Filename)
            %grab pressure and diameter from trial
           
            %extract input and add one for correct indexing
            D = extractBetween(Filename,"d","-");
            
            P = extractBetween(Filename,"p","-");
            
            %get the correct index for the trial
            Dindex = findIndex(Deflector.Diameters,D);
            Pindex = findIndex(Deflector.Pressures,P);
            if isempty(Dindex)
                %add the diameter to the list
                Deflector.Diameters = [Deflector.Diameters D];
                Dindex = findIndex(Deflector.Diameters,D);
            end
            if isempty(Pindex)
                %add the pressure to the list
                Deflector.Pressures = [Deflector.Pressures P];
                Pindex = findIndex(Deflector.Pressures,P);
            end
            
            
            %read in and generate trial data
            try 
                data  = dlmread(Filename,'\t',1,1);
            catch
                data = [];
                disp(['Diameter ' D 'Pressure ' P ' did not work'])
            end
            
            %create a Trial
            test = deflectionTrial(data);
            
            %if the Dindex or Pindex is out of bounds save the old Trials index and copy it into a new boundry space 
            if Dindex > size(Deflector.Trials,1) || Pindex > size(Deflector.Trials,2)
                %save the old matrix
                oldMatrix = Deflector.Trials;
                
                
                if Dindex > size(Deflector.Trials,1) && Pindex > size(Deflector.Trials,2)
                    %create new correct size one
                    newMatrix(1:Dindex,1:Pindex) = deflectionTrial([]);
                   
                elseif Pindex > size(Deflector.Trials,2)
                    %create new correct size one
                    newMatrix(1:size(Deflector.Trials,1),1:Pindex) = deflectionTrial([]);
                    
                else
                    %create new correct size one
                    newMatrix(1:Dindex,1:size(Deflector.Trials,2)) = deflectionTrial([]);
                    
                end
                if ~isempty(oldMatrix)
                    newMatrix(1:size(oldMatrix,1),1:size(oldMatrix,2)) = oldMatrix;
                end
                
                %create new matrix
                Deflector.Trials = newMatrix;
                
                
            end
            Deflector.Trials(Dindex,Pindex) = test;
            
            
        end
        
        
        function plot_psi(Deflector, PSI)
            %plots all diameter data for psi
            
            %create color array
            index = findIndex(Deflector.Pressures,PSI);
            colors = hsv(size(Deflector.Trials,1) + 1);
            
            %create one figure with all the diameter data for the psi
            fig1 = figure('NumberTitle', 'off', 'Name', ['\fontsize{20}' 'Thickness ' num2str(Deflector.Thickness) 'PSI ' char(Deflector.Pressures(index))]);
            clf(fig1);
            hold on;
            for i = 1:size(Deflector.Trials,1)
                
                if ~isempty(Deflector.Trials(i,index).Stats)
                    scatter(Deflector.Trials(i,index).Stats(:,1),Deflector.Trials(i,index).Stats(:,2), 36, colors(i,:), 'filled');
                end
            end
            legend(Deflector.Diameters);
            xlabel('Force (mN)');
            ylabel('Displacement (um)');
            title(['\fontsize{20}' 'Thickness ' num2str(Deflector.Thickness) 'PSI ' char(Deflector.Pressures(index))]);
            set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
            
            
        end
        
        
    end
end

