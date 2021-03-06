%% clear previous program and enter the required directories
clear all
vid_dir = 'C:\Users\alex\Documents\FC_videos\AmScope';
file_dir = 'C:\Users\alex\Dropbox\FC_matlab_library';
project_dir = 'C:\Users\alex\Dropbox\FC_matlab_library\Chip_timing';
RAM_dir = 'R:\';

cd(vid_dir);
addpath(file_dir);
addpath(project_dir);
addpath(RAM_dir);

folder = dir;

%% Create the fluidic chip with version

FC = fluidicChip_statistics('M3AR_1');


%% take in the filenames for a single test
filenames = {folder(1).name};
for k = 2:length(folder)
    filenames = cat(2,{folder(k).name},filenames);
end

%if the filename has the version in it store it in the video matrix
model = FC.model;
for k = 1:length(filenames)
    file = char(filenames(k));
    if strcmp(extractBefore(file,'_r'),model) == 1
       FC = FC.store_video(file); 
    end
end

%% take in multiline test files
filenames = {folder(1).name};
for k = 2:length(folder)
    filenames = cat(2,{folder(k).name},filenames);
end

%if the filename has the version in it store it in the video matrix
model = FC.model;
for k = 1:length(filenames)
    file = char(filenames(k));
    if strcmp(extractBefore(file,'_S'),model) == 1 && ~strcmp(extractAfter(file,'.'),'txt')
         FC = FC.store_video(file); 
    end
end


