function [object] = deflectionTrial_grabber(trial)
%deflectionTrial_grabber goes into the excel folder and grabs the appropriate deflection

%generate target name of excel document
if trial{2} == 'P'
    target = ['piezo' num2str(trial{1})];
else
    target = ['disp' num2str(trial{1}) '_p' num2str(trial{2}) '_t' num2str(trial{3}) '_d' num2str(trial{4}) '_r' num2str(trial{5}) '_c' num2str(trial{6}) '_m' num2str(trial{7}) '_v' trial{8} '_'];
end

excel_dir = 'C:\Users\alex\Dropbox\Bubble Deflection Testing - NIH Phase I NH\dlmread_friendly\All';
file_dir = 'C:\Users\alex\Dropbox\FC_matlab_library';
RAM_dir = 'R:\';

cd(excel_dir);
addpath(file_dir);
addpath(RAM_dir);

folder = dir;

%grab names from folder
filenames = {folder(1).name};
for k = 2:length(folder)
    filenames = cat(2,{folder(k).name},filenames);
end

%search for name that matches target
for k = 1:length(filenames)
    file = char(filenames(k));
    if strcmp(file,target) == 1
        %read in and generate trial data
        try
            data  =  dlmread(file,'\t',1,1);
            data(:,1)  = data(:,1) - min(data(:,1));
            object = deflectionTrial(data);
           
            
        catch
            disp([target 'did not work'])
        end
    end
end
end