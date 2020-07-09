%% Enter the required directories and create desired variables
vid_dir = 'C:\Users\alex\Documents\FC_videos\AmScope';
file_dir = 'C:\Users\alex\Dropbox\FC_matlab_library';
RAM_dir = 'R:\';

cd(vid_dir);
addpath(file_dir);
addpath(RAM_dir);

folder = dir;

dimensions = size(FC.chip);
rows = dimensions(1);
columns = dimensions(2);
model = FC.model;


%% Generate all brightness graphs

for i = 1:rows
    for j = 1:columns
        for in = 0:1

            FC.generate_cellBrightnessdata([i j], in);

        end
    end
end

%% Generate combined brightness graphs


FC.generate_allBrightnessdata([1:8],[1:8],2);

