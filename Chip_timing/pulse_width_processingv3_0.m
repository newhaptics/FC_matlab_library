%% clear previous program and enter the required directories
vid_dir = 'C:\Users\alex\Documents\FC_videos\AmScope';
RAM_dir = 'R:\';
file_dir = 'C:\Users\alex\Dropbox\FC_matlab_library';
func_dir = 'C:\Users\alex\Dropbox\FC_matlab_library\Chip_timing';

cd(vid_dir)
addpath(RAM_dir)
addpath(file_dir)
addpath(func_dir)

save_data = 1;  % 0 to turn off save-data

%% get crop data
dimensions = size(FC.chip);
rows = dimensions(1);
columns = dimensions(2);
model = FC.model;


for j = 1:columns
    for i = 1:rows
        
        for in = 0:1
            
            file = FC.get_videoFile([i j], in);
            
            if isempty(file{1}) == 0
    
                FC = FC.get_cropData([i j],in);
                
            end
            
        end
    end
end


%% get cell and timing data
dimensions = size(FC.chip);
rows = dimensions(1);
columns = dimensions(2);
model = FC.model;

for j = 1:columns
    for i = 1:rows
        
        for in = 0:1
                
            file = FC.get_videoFile([i j], in);
            
            if isempty(file{1}) == 0
                % generate data from crop
                disp(['processing brightness data for row ' num2str(i) ' column ' num2str(j) ' input ' num2str(in)]);
                tic
                FC = FC.get_cellData([i j], in);
                toc
                disp(['processing timing data for row ' num2str(i) ' column ' num2str(j) ' input ' num2str(in)]);
                tic
                FC = FC.get_timingData([i j],in);
                toc
            end
            
        end
    end
end
