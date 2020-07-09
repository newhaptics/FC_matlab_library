%% clear previous program and enter the required directories
clear all
excel_dir = 'C:\Users\Alex\Documents\Bubble_Deflection_Testing';
file_dir = 'C:\Users\Alex\Documents\FC_matlab_library';
RAM_dir = 'R:\';

cd(excel_dir);
addpath(file_dir);
addpath(RAM_dir);

folder = dir;

%% Create the deflection testing data structures

deflector200 = FC_deflection(200);

%% populate the deflection chip with trials
filenames = {folder(1).name};
for k = 2:length(folder)
    filenames = cat(2,{folder(k).name},filenames);
end

%if the filename has the version in it store it in the video matrix
thickness = ['t' num2str(deflector200.Thickness)];
for k = 1:length(filenames)
    file = char(filenames(k));
    if strcmp(extractBefore(file,'-d'),thickness) == 1 && ~strcmp(extractBetween(file,"d","-"),'all')
       deflector200 = deflector200.add_trial(file); 
    end
end