%% clear previous program and enter the required directories
clear all
vid_dir = 'C:\Users\Alex\Documents\AmScope';
RAM_dir = 'R:\';
file_dir = 'C:\Users\alex\Dropbox\Chip Timing\Results';
func_dir = 'C:\Users\alex\Dropbox\Chip Timing';

cd(vid_dir)
addpath(RAM_dir)
addpath(file_dir)
addpath(func_dir)

save_data = 1;  % 0 to turn off save-data
%% ask user for size of the board being tested
chip = 0;
while ~isequal(size(chip),[1 2])
    chip = input('specify the size of the chip tested  ');
end
%make first page of chip
chip = zeros(chip(1),chip(2));

chipGate_data = {'front_delay','drop_time','rise_time','back_delay','pulse_duration','gate_off'};
chipIn_data = {'front_delay','rise_time','steady_state','drop_time','back_delay','pulse_duration'};
chipOut_data = {'internal propagation','change_time'};

% create the data matrices for a chip of that size
chipGate_times = dataMatrix_maker(chip,length(chipGate_data));
chipIn_times = dataMatrix_maker(chip,length(chipIn_data));
chipOut_times = dataMatrix_maker(chip,length(chipOut_data));


%% take in a video file and create an object
filename = 'M2A_1_r6_c6_in1_s-46000_h268000_p80000_20200305T164715';
video_ext = '.avi';

%find the row and column from filename
location = [str2double(extractBetween(filename,"r","_")) str2double(extractBetween(filename,"c","_"))];

%extract input
input = str2double(extractBetween(filename,"in","_"));

if isfile([RAM_dir '/' filename video_ext])
    copyfile([RAM_dir '/' filename video_ext]);
    delete([RAM_dir '/' filename video_ext]);
end

video = VideoReader([vid_dir '/' filename video_ext]);
%% names of cropping regions

% Label the areas of interest in order unique
name = {'ledTimer','gateLed','chipGate','chipIn','chipOut'};

% Number of areas of interest based on labels
outputs = length(name);

%% find the position matrix of crop regions, and calculate the average brightness and differential region

posMatrix = position_matrix(video,name);
avgBright = average_brightness(posMatrix,video);
df = diff(avgBright);
avgBright(end,:) = [];
[pulseDf, pulseBright] = pulseCrop(avgBright,df,name);

%% add the timing data to the chip timing matrices

[chipGate_times(location(1),location(2),:), chipIn_times(location(1),location(2),:), chipOut_times(location(1),location(2),:)] = pulseData(pulseBright,name,chipGate_data,chipIn_data,chipOut_data);

%% create graphs and alignment for pulse

plotData(avgBright,df,name);
plotData(pulseBright,pulseDf,name);

%%
if save_data==1
    save([vid_dir '/' filename '.mat']); % Save the data
    save([file_dir '/' filename '.mat']); % Save the data
end
