classdef fluidicChip_statistics
    %fluidicChip_statistics holds all the info on a fluidic chip
    %   contains loads of data on the timing and other properties of the
    %   fluidic chip

    properties

        %chip model number
        model;
        %chip size and blank matrix to add to other data matrices
        chip;


        %Label the areas of interest in order unique
        interestAreas = {'gateLed','electronicGate','electronicIn','chipGate','chipIn','chipOut'};

        %timing data in each cell
        timeContainer;

        %matrix of brightness data for chip
        brightMatrix;

        %object to hold all the video data
        videoContainer;

        %recent crop data
        cropData;

    end

    methods

        function FC = fluidicChip_statistics(version)
            %create a fluidic chip

            FC.model = version;

            FC.chip = 0;
            while ~isequal(size(FC.chip),[1 2])
                FC.chip = input('specify the size of the chip tested  ');
            end
            %create brightness matrix
            rows = FC.chip(1);
            columns = FC.chip(2);
            A(1:rows,1:columns) = brightnessData([],[],[],[]);


            %make first page of chip
            FC.chip = NaN(rows,columns);

            %create the videocontainer matrices
            vidMat = cell(rows,columns);
            frameMat = FC.chip;
            cropMat = FC.dataMatrix_maker(zeros(length(FC.interestAreas),4),numel(FC.chip));
            B(1:2) = videoData(vidMat,cropMat, frameMat);


            %make timing matrices for a chip of its size
            C = timingData(0,0,0,0);
            Gate = FC.dataMatrix_maker(FC.chip,length(C.chipGate_data));
            In = FC.dataMatrix_maker(FC.chip,length(C.chipIn_data));
            Out = FC.dataMatrix_maker(FC.chip,length(C.chipOut_data));
            Trig = FC.dataMatrix_maker(FC.chip,length(C.chipTrig_data));
            C(1:2) = timingData(Gate, In, Out, Trig);

            %create two of each containers for data
            %index 1 is 0 in and index 2 is 1 in
            FC.brightMatrix = A;
            FC.videoContainer = B;
            FC.timeContainer = C;

        end

        function FC = store_video(FC,filename)

            %check if a multiline file
            if strcmp(extractBefore(filename,'_S'),FC.model) == 1 && ~strcmp(extractAfter(filename,'.'),'txt')
                %get txt file
                txtName = [char(extractBefore(filename,'D')) char('D.txt')];

                %open the file
                if ~exist(txtName)
                    errorMessage = sprintf('Error: file %s not found.  Click OK to exit.\n', txtName);
                    fprintf('%s\n', errorMessage);
                    uiwait(warndlg(errorMessage));
                    return;
                end
                fileID=fopen(txtName);
                txtString = fscanf(fileID,'%s');

                %get number of elements
                num = str2double(extractBetween(txtString,'S','_'));

                %loop through and store elemnt in proper place
                for i = 1:num
                    elem = ['E' num2str(i) '_'];

                    %get filename for each element
                    elementName = extractBetween(txtString,elem,'_E');

                    %find the row and column from filename

                    location = [str2double(extractBetween(elementName,"r","_")) str2double(extractBetween(elementName,"c","_"))];

                    %extract input and add one for correct indexing
                    input = str2double(extractBetween(elementName,"in","_")) + 1;

                    %add the video to the correct video container
                    FC.videoContainer(input).videoMatrix(location(1),location(2)) = {filename};

                end

            elseif  ~strcmp(extractAfter(filename,'.'),'txt')

            %takes in the name of a video file and stores it in the appropriate cell
            %find the row and column from filename

            location = [str2double(extractBetween(filename,"r","_")) str2double(extractBetween(filename,"c","_"))];

            %extract input and add one for correct indexing
            input = str2double(extractBetween(filename,"in","_")) + 1;

            %add the video to the correct video container
            FC.videoContainer(input).videoMatrix(location(1),location(2)) = {filename};

            end
        end

        function filename = get_videoFile(FC,location,input)
            filename = FC.videoContainer(input + 1).videoMatrix(location(1),location(2));
        end

        function FC = get_cropData(FC,location,in)

            disp({'cropping at row ' location(1) ' column ' location(2) ' input ' in});

            reply='';
            reply=input('Do you want to pick new crop regions? y/[] (yes/use previous) : ','s');


            %try to crop if fail try again
            try
                if strcmp(reply,'y')==1
                    %create video reader for cell
                    video = FC.create_reader(location,in);

                    %get the position matrix for the cell
                    posMatrix = position_matrix(video,FC.interestAreas);


                    %index in the crop matrix
                    index = FC.get_cropIndex(location);

                    %place the crop matrix in its proper place
                    FC.videoContainer(in + 1).cropMatrix(:,:,index) = posMatrix;
                    FC.cropData = posMatrix;
                else
                    %use the previous crop data
                    %index in the crop matrix
                    index = FC.get_cropIndex(location);
                    FC.videoContainer(in + 1).cropMatrix(:,:,index) = FC.cropData;
                end

            catch
                disp('Something went wrong retrying element crop...');
                FC.get_cropData(location,in);

            end


        end


        function FC = get_cellData(FC,location,input)
            %create video reader for cell
            video = FC.create_reader(location,input);

            %grab posMatrix
            %index in the crop matrix
            index = FC.get_cropIndex(location);
            posMatrix = FC.videoContainer(input + 1).cropMatrix(:,:,index);


            %calculate the average brightness and the cropped versions
            avgBright = average_brightness(posMatrix,video);
            
            %flip the output data for easy recording
            index = findIndex(FC.interestAreas,'chipOut');
            avgBright(:,index) = max(avgBright(:,index)) - avgBright(:,index) + min(avgBright(:,index));

            %add the electronic gate and in data
            %grab setup hold and pw times

            [S,E,s, h, pw] = FC.get_SEshpw(location,input);
            video = FC.create_reader(location,input);
            frameRate = video.FrameRate;
            s = s/1000;
            h = h/1000;
            pw = pw/1000;

            avgBright = add_electronicData(avgBright,FC.interestAreas,s,h,pw,frameRate,E,S);

            [normalData, ~] = FC.normalize_data(avgBright, avgBright, size(avgBright,1));


            df = diff(normalData);
            avgBright(end,:) = [];



            %store inside of the brightMatrix container
            A = FC.brightMatrix(location(1),location(2));
            A = FC.store_brightnessData(avgBright,df,input,A);
            FC.brightMatrix(location(1),location(2)) = A;

        end

        function FC = get_timingData(FC,location,input)
            row = location(1);
            column = location(2);

            %if input is 0 grab from data 0
            if input == 0
                [avgBright, df, pulseBright, pulseDf] = FC.get_brightData(location,input);
            end

            %if input is 1 grab from data 1
            if input == 1
                [avgBright, df, pulseBright, pulseDf] = FC.get_brightData(location,input);
            end

            if isempty(pulseBright) == 0
                Gate_data = FC.timeContainer(input+1).chipGate_data;
                In_data = FC.timeContainer(input+1).chipIn_data;
                Out_data = FC.timeContainer(input+1).chipOut_data;
                Trig_data = FC.timeContainer(input+1).chipTrig_data;

                %get the setup hold and pulse width
                [~,~,s, h, pw] = FC.get_SEshpw(location,input);


                [Gate_times, In_times, Out_times, Trig_times] = pulseData(pulseBright,FC.interestAreas,Gate_data,In_data,Out_data, Trig_data, input, s, h, pw);

                FC.timeContainer(input + 1).chipGate_times(row,column,:) = Gate_times;
                FC.timeContainer(input + 1).chipIn_times(row,column,:) = In_times;
                FC.timeContainer(input + 1).chipOut_times(row,column,:) = Out_times;
                FC.timeContainer(input + 1).chipTrig_times(row,column,:) = Trig_times;

                %fill the framerate matrix
                video = FC.create_reader(location,input);

                FC.videoContainer(1,input + 1).framerateMatrix(row,column) = video.framerate*16;




            else
                disp({'no pulse found at' row column});
            end


        end


        function [S,E,s,h,pw] = get_SEshpw(FC,location,input)
            %This function grabs the setup, hold and pulsewidth from a certain
            %location and input of an FC

            %get filename for location
            filename = FC.videoContainer(1,input + 1).videoMatrix(location(1),location(2));

            %check if a multiline file
            if strcmp(extractBefore(filename,'_S'),FC.model) == 1 && ~strcmp(extractAfter(filename,'.'),'txt')
                %get txt file
                txtName = [char(extractBefore(filename,'D')) char('D.txt')];

                %open the file
                if ~exist(txtName)
                    errorMessage = sprintf('Error: file %s not found.  Click OK to exit.\n', txtName);
                    fprintf('%s\n', errorMessage);
                    uiwait(warndlg(errorMessage));
                    return;
                end
                fileID=fopen(txtName);
                txtString = fscanf(fileID,'%s');

                %grab proper setup and hold time from the file
                elem = ['_r' num2str(location(1)) '_c' num2str(location(2)) '_in' num2str(input)];

                %get the setup hold and pulse width

                shpw = extractBetween(txtString,elem,'_E');
                s = [str2double(extractBetween(shpw,'s','_h'))];
                h = [str2double(extractBetween(shpw,'h','_p'))];
                pw = [str2double(extractAfter(shpw,'p'))];

                %get S and E
                E = extractBefore(txtString,elem);
                E = [str2double(E(end))];
                S = [str2double(extractBetween(txtString,'S','_'))];

            elseif  ~strcmp(extractAfter(filename,'.'),'txt')

                s = [str2double(extractBetween(filename,"s","_"))];
                h = [str2double(extractBetween(filename,"h","_"))];
                pw = [str2double(extractBetween(filename,"p","_"))];

                S = [];
                E = [];
                
                
            end
            
        end
        
        
        
        function generate_cellBrightnessdata(FC,location,input)
            
            [avgBright, df, pulseBright, pulseDf] = FC.get_brightData(location,input);
            
            localString = ['cell [' num2str(location(1)) ' ' num2str(location(2)) '] input ' num2str(input)];
            
            if ~isempty(avgBright)
                
                %interpolate data to correct length for the chipGate,
                %chipIn and chipOut normalize around the pulse
                [avgBright,df] = FC.rawData_normalizer(avgBright,df);
                [pulseBright, pulseDf] = FC.normalize_data(pulseBright, pulseDf, size(pulseBright,1));
                
                plotData(avgBright,df,FC.interestAreas, ['\fontsize{20}' 'Raw Brightness Data ' localString]);
                figname = [FC.model 'fig4'];
                savefig(figname);
                set(gcf, 'units', 'normalized', 'position', [1 -.425 .57 .825]);
                plotData(pulseBright,pulseDf,FC.interestAreas, ['\fontsize{20}' 'Gate Pulse Brightness Data ' localString]);
                figname = [FC.model 'fig5'];
                savefig(figname);
                set(gcf, 'units', 'normalized', 'position', [1 .475 .57 .825]);
            else
                disp(['no data in ' localString]);
            end
            
        end
        
        function generate_allBrightnessdata(FC,rowCrop,columnCrop,input)
            % input 0 for 0 input 1 for 1 and input 2 for both
            % crop allows a selection of the chip rowCrop crops the rows
            % and columnCrop crops the columns
            
            dimensions = size(FC.chip);
            rows = dimensions(1);
            columns = dimensions(2);
            
            
            if input == 2
                input = 0:1;
            end
            
            cropString = ['rows [' num2str(rowCrop(1)) ' ' num2str(rowCrop(end)) '] columns [' num2str(columnCrop(1)) ' ' num2str(columnCrop(end)) '] input [' num2str(input) ']'];
            
            %check that crop is of correct size
            if ((rowCrop(1) >= 1) && (rowCrop(end) <= rows)) && ((columnCrop(1) >= 1) && (columnCrop(end) <= columns))
                
                
                [avgLength, pulseLength, numPoints, first_frame] = FC.get_frameSize([rowCrop(1) rowCrop(end)],[columnCrop(1) columnCrop(end)],input);
                
                %create color array
                colors = hsv(numPoints);
                numPoints = 1;
                
                %create two figures one for pulse and one for normal data
                fig1 = figure('NumberTitle', 'off', 'Name', ['\fontsize{20}' 'Raw LED aligned Brightness Data ' cropString]);
                clf(fig1);
                subplot(length(FC.interestAreas), 1, 1);
                title(['\fontsize{20}' 'Raw Brightness Data ' cropString]);
                figname1 = [FC.model 'fig1'];
                savefig(figname1);
                fig2 = figure('NumberTitle', 'off', 'Name', ['\fontsize{20}' 'Gate Pulse Brightness Data ' cropString]);
                clf(fig2);
                subplot(length(FC.interestAreas), 1, 1);
                title(['\fontsize{20}' 'Gate Pulse Brightness Data ' cropString]);
                figname2 = [FC.model 'fig2'];
                savefig(figname2);
                fig3 = figure('NumberTitle', 'off', 'Name', ['\fontsize{20}' 'Raw Pulse Brightness Data ' cropString]);
                clf(fig3);
                subplot(length(FC.interestAreas), 1, 1);
                title(['\fontsize{20}' 'Gate Pulse Brightness Data ' cropString]);
                figname3= [FC.model 'fig3'];
                savefig(figname3);
                
                %cycle through the correct rows and columns and add the
                %brightness data to the graph
                for i = rowCrop(1):rowCrop(end)
                    for j = columnCrop(1):columnCrop(end)
                        for state = input
                            
                            localString = ['cell [' num2str(i) ' ' num2str(j) '] input ' num2str(state)];
                            
                            [avgBright, df, pulseBright, pulseDf] = FC.get_brightData([i j],state);
                            
                            
                            if ~isempty(avgBright)
                                
                                
                                %interpolate data to correct length
                                [avgBright, df] = FC.rawData_normalizer(avgBright,df,[i j],state);
                                [pulseBright, pulseDf] = FC.normalize_data(pulseBright, pulseDf, pulseLength);
                                
                                
                                %pad the data to get proper length
                                %avgBright = [avgBright;zeros(avgLength - length(avgBright),length(FC.interestAreas)) + mean(avgBright)];
                                %df = [df;zeros(avgLength - length(df),length(FC.interestAreas)) + mean(df)];
                                %pulseBright = [pulseBright;zeros(pulseLength - length(pulseBright),length(FC.interestAreas)) + mean(pulseBright)];
                                %pulseDf = [pulseDf;zeros(pulseLength - length(pulseDf),length(FC.interestAreas)) + mean(pulseDf)];
                                
                                %create time to line up gates
                                start = max(max(max(first_frame))) - first_frame(i,j,state + 1) + 1;
                                t = start:(size(avgBright,1) + start - 1);
                                
                                
                                disp(['adding plot data in ' localString '...']);
                                add_plotData(avgBright,df,FC.interestAreas, t, fig1,localString, colors(numPoints,:));
                                add_plotData(pulseBright,pulseDf,FC.interestAreas, 1:pulseLength, fig2,localString, colors(numPoints,:));
                                add_plotData(avgBright,df,FC.interestAreas, 1:size(avgBright,1), fig3,localString, colors(numPoints,:));
                                numPoints = numPoints + 1;
                                
                            else
                                disp(['no data in ' localString]);
                            end
                            
                        end
                    end
                end
                figure(fig1);
                savefig(figname1);
                close(fig1);
                figure(fig2);
                savefig(figname2);
                close(fig2);
                figure(fig3);
                savefig(figname3);
                close(fig3);
            else
                disp(['crop dimensions incorrect rows ' num2str(rowCrop) ' columns ' num2str(columnCrop)]);
            end
            
            
            
        end



        function generate_timingData(FC,input)

            gateHeader = [FC.model ' Gate Timing Input ' num2str(input)];
            inHeader = [FC.model ' In Timing Input ' num2str(input)];
            outHeader = [FC.model ' Out Timing Input ' num2str(input)];
            trigHeader = [FC.model ' Trigger Timing Input ' num2str(input)];

            gateMatrix = FC.timeContainer(1,input + 1).chipGate_times ./ FC.videoContainer(1,input + 1).framerateMatrix * 1000;
            inMatrix = FC.timeContainer(1,input + 1).chipIn_times ./ FC.videoContainer(1,input + 1).framerateMatrix * 1000;
            outMatrix = FC.timeContainer(1,input + 1).chipOut_times ./ FC.videoContainer(1,input + 1).framerateMatrix * 1000;
            trigMatrix(:,:,1:3) = FC.timeContainer(1,input + 1).chipTrig_times(:,:,1:3) ./ FC.videoContainer(1,input + 1).framerateMatrix * 1000;
            trigMatrix(:,:,4:6) = FC.timeContainer(1,input + 1).chipTrig_times(:,:,4:6);

            %create a differenc matrix
            trigDiff_mat = trigMatrix(:,:,1:3) - trigMatrix(:,:,4:6);
            trigDiff_data = {'Setup Diff','Hold Diff','Pulse Width Diff'};
            %diffHeader = 'Setup, Hold, Pulse Width Differences';

            %merge diff and trig matrices
            trigMatrix = cat(3,trigMatrix,trigDiff_mat);


            make_heatMap(gateMatrix,FC.timeContainer(1,2).chipGate_data, gateHeader);
            set(gcf, 'units', 'normalized', 'position', [1 -.425 .57 .825]);
            make_heatMap(inMatrix,FC.timeContainer(1,2).chipIn_data, inHeader);
            set(gcf, 'units', 'normalized', 'position', [1 .475 .57 .825]);
            make_heatMap(outMatrix,FC.timeContainer(1,2).chipOut_data, outHeader);
            set(gcf, 'units', 'normalized', 'position', [0 0 .5 0.9]);
            make_heatMap(trigMatrix,[FC.timeContainer(1,2).chipTrig_data trigDiff_data], trigHeader);
            set(gcf, 'units', 'normalized', 'position', [0.5 0 .5 0.9]);
            %make_heatMap(trigDiff_mat, trigDiff_data, diffHeader)
            %set(gcf, 'units', 'normalized', 'position', [0.5 0 .5 0.9]);

        end



    end

    methods (Access = private)



        function [normalizedData, normalizedDif] = normalize_data(FC,rawData, rawDif, resolution)

            %process the data
            %smooth incoming data to sharpen edges
            for i = 1:size(rawData,2)
                if ~contains(FC.interestAreas(i),'electronic') && ~contains(FC.interestAreas(i),'gateLed')
                    rawData(:,i) = smooth(rawData(:,i),7,'rlowess');
                    rawData(:,i) = smooth(rawData(:,i),3,'loess');
                end
            end

            %process the diff
            %smooth incoming data to exectuate spikes
            for i = 1:size(rawDif,2)
                rawDif(:,i) = smooth(rawDif(:,i),20,'sgolay');
            end


            t = linspace(1,size(rawData,1),resolution)';
            %add more points on the x axis
            normalizedData = interp1(rawData,t);
            %shrink y to between 0 and y size
            normalizedData = normalizedData - min(abs(normalizedData));
            normalizedData = (normalizedData./max(abs(normalizedData)));

            t = linspace(1,size(rawDif,1),resolution)';
            %add more points on the x axis
            normalizedDif = interp1(rawDif,t);
            %shrink y to between 0 and y size
            normalizedDif = normalizedDif - min(abs(normalizedDif));
            normalizedDif = (normalizedDif./max(abs(normalizedDif)));


        end

        function [normalBright,normalDf] = rawData_normalizer(FC,avgBright,df,location,input)
            %rawData_normalizer if the data is chipGate, chipIn, or chipOut normalize to the
            %pulse
            %find the pulsecrop of the vectors
            %check for fucky gate pulse
            [S,E,~,~,~] = get_SEshpw(FC,location,input);
            if isempty(S)
                [pulseDf, pulseBright,fallEdge,riseEdge] = pulseCrop(avgBright, df, FC.interestAreas);
            else
                [pulseDf, pulseBright,fallEdge,riseEdge] = multi_pulseCrop(avgBright, df, FC.interestAreas,S,E);
            end
            
            pulseBuffer = 1;

            %find the index of the chipGate chipIn and chipOut data and
            %extract each vector column
            gateIndex = findIndex(FC.interestAreas,'chipGate');
            inIndex = findIndex(FC.interestAreas,'chipIn');
            outIndex = findIndex(FC.interestAreas,'chipOut');
            gateVec = pulseBright(pulseBuffer:(end - pulseBuffer + 1),gateIndex);
            gateDif = pulseDf(pulseBuffer:(end - pulseBuffer + 1),gateIndex);
            inVec = pulseBright(pulseBuffer:(end - pulseBuffer + 1),inIndex);
            inDif = pulseDf(pulseBuffer:(end - pulseBuffer + 1),inIndex);
            outVec = pulseBright(pulseBuffer:(end - pulseBuffer + 1),outIndex);
            outDif = pulseDf(pulseBuffer:(end - pulseBuffer + 1),outIndex);

            %add 20 to fall Edge and subtract 20 from riseEdge

            %normalize the vectors
            [gateVec, gateDif] = FC.normalize_data(gateVec, gateDif, size(gateVec,1));
            [inVec, inDif] = FC.normalize_data(inVec, inDif, size(inVec,1));
            [outVec, outDif] = FC.normalize_data(outVec, outDif, size(outVec,1));

            %merge the properly normalized vectors with the old data
            gateVec = [avgBright(1:fallEdge, gateIndex); gateVec; avgBright(riseEdge:end, gateIndex)];
            gateDif = [df(1:fallEdge, gateIndex); gateDif; df(riseEdge:end, gateIndex)];
            inVec = [avgBright(1:fallEdge, inIndex); inVec; avgBright(riseEdge:end, inIndex)];
            inDif = [df(1:fallEdge, inIndex); inDif; df(riseEdge:end, inIndex)];
            outVec = [avgBright(1:fallEdge, outIndex); outVec; avgBright(riseEdge:end, outIndex)];
            outDif = [df(1:fallEdge, outIndex); outDif; df(riseEdge:end, outIndex)];

            %normalize everthing
            [normalBright,normalDf] = FC.normalize_data(avgBright, df, size(avgBright,1));

            %inject the vectors
            normalBright(:,gateIndex) = gateVec;
            normalDf(:,gateIndex) = gateDif;
            normalBright(:,inIndex) = inVec;
            normalDf(:,inIndex) = inDif;
            normalBright(:,outIndex) = outVec;
            normalDf(:,outIndex) = outDif;

        end


        function [avgLength, pulseLength, numPoints, first_frame] = get_frameSize(FC,rows,columns,input)

            index = findIndex(FC.interestAreas,'gateLed');
            first_frame = FC.dataMatrix_maker(FC.chip,2);
            avgLength = 0;
            pulseLength = 0;
            numPoints = 0;
            %find the largest frame length in the crop region
            for i = rows(1):rows(2)
                for j = columns(1):columns(2)
                    for state = input

                        [avgBright, df, pulseBright, pulseDf] = FC.get_brightData([i j],state);


                        if avgLength < size(avgBright,1)
                            avgLength = size(avgBright,1);
                        end
                        if pulseLength < size(pulseBright,1)
                            pulseLength = size(pulseBright,1);
                        end
                        if ~isempty(avgBright)
                            numPoints = numPoints + 1;
                            
                            %check for fucky gate pulse
                            [S,E,~,~,~] = get_SEshpw(FC,[i j],state);
                            if isempty(S)
                                [~,~,gate,~] = pulseCrop(avgBright, df, FC.interestAreas);
                            else
                                [~,~,gate,~] = multi_pulseCrop(avgBright, df, FC.interestAreas,S,E);
                            end
                            first_frame(i,j,state + 1) = gate;
                        end

                    end
                end
            end

        end

        function [avgBright, df, pulseBright, pulseDf] = get_brightData(FC,location,input)
            row = location(1);
            column = location(2);

            if input == 0
                avgBright = FC.brightMatrix(row,column).avgBright0;
                df = FC.brightMatrix(row,column).df0;
                if ~isempty(avgBright)
                    %check for fucky gate pulse
                    [S,E,~,~,~] = get_SEshpw(FC,location,input);
                    if isempty(S)
                        [pulseDf, pulseBright,~,~] = pulseCrop(avgBright, df, FC.interestAreas);
                    else
                        [pulseDf, pulseBright,~,~] = multi_pulseCrop(avgBright, df, FC.interestAreas,S,E);
                    end
                else
                    pulseDf = [];
                    pulseBright = [];
                end
            end
            if input == 1
                avgBright = FC.brightMatrix(row,column).avgBright1;
                df = FC.brightMatrix(row,column).df1;
                if ~isempty(avgBright)
                    %check for fucky gate pulse
                    [S,E,~,~,~] = get_SEshpw(FC,location,input);
                    if isempty(S)
                        [pulseDf, pulseBright,~,~] = pulseCrop(avgBright, df, FC.interestAreas);
                    else
                        [pulseDf, pulseBright,~,~] = multi_pulseCrop(avgBright, df, FC.interestAreas,S,E);
                    end
                else
                    pulseDf = [];
                    pulseBright = [];
                end
            end
        end

        function brightData = store_brightnessData(~,avgBright,df,input,Data)

            % if input is 0
            if input == 0
                Data.avgBright0 = avgBright;
                Data.df0 = df;
            end

            %if input is 1
            if input == 1
                Data.avgBright1 = avgBright;
                Data.df1 = df;
            end

            brightData = Data;

        end


        function index = get_cropIndex(FC,location)
            dimensions = size(FC.chip);
            index = location(1) + location(2)*dimensions(2);
        end

        function video = create_reader(FC,location,input)
           path = FC.videoContainer(input + 1).video_path(location);
           video = VideoReader(path);
        end

        function chip_times = dataMatrix_maker(~,mat,size)
            % dataMatrix_maker creates a 3d matrix of the appropriate size given the
            % chip and the amount of data to collect
            chip_times = mat;
            for k = 1:size - 1
                chip_times = cat(3,chip_times,mat);
            end
        end


    end


end
