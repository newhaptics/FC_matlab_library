function add_dispTrial(trial,color)
%addtrial takes in all the parameters you would like to plot and grabs
%that file and add it to the plot

%generate target name of excel document
target = ['disp' num2str(trial{1}) '_p' num2str(trial{2}) '_t' num2str(trial{3}) '_d' num2str(trial{4}) '_r' num2str(trial{5}) '_c' num2str(trial{6}) '_m' num2str(trial{7}) '_v' trial{8} '_'];

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
            old_legend = findobj(gcf,'Type', 'legend');
            
            if ~isempty(old_legend)
                lString = [old_legend.String char([target 'uprange']) char([target ' downrange'])];
            end
            
            
            data  = dlmread(file,'\t',1,1);
            [uprange, downrange] = turn_around(data);
            plot(data(uprange,1),data(uprange,2),'-','color',color);
            plot(data(downrange,1),data(downrange,2),'--','color',color);
            
            if ~isempty(old_legend)
                legend(lString);
            else
                legend([target 'uprange'], [target ' downrange']);
            end
            
            
        catch
            disp([target 'did not work'])
        end
    end
end




end

