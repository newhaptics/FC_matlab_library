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


FC.generate_allBrightnessdata([1:15],[1:14],2);


%% graph adjustment parameters
x_limits = [0 inf];
y_limits = [0 1];
df = 0;
display_off = '0';


h = openfig('fig1');
for i = 1:6
    handles = findobj(h,'Type','axes');
    xlim(handles(i), x_limits);
    if i < 4
        handles(i).YLim = y_limits;
    end
    %uncheck all df graphs
    L = get(handles(i),'children');
    for k=1:length(L)
        s = split(L(k).DisplayName);
        if size(s,1) == 6 && ~df
            set(L(k),'visible','off');
        elseif strcmp(s(5),display_off)
            set(L(k),'visible','off');
        end
    end
end
plotbrowser(h,'on');



%%
h = openfig('fig2');
for i = 1:6
    handles = findobj(h,'Type','axes');
    xlim(handles(i), x_limits);
    if i < 4
        handles(i).YLim = y_limits;
    end
    %uncheck all df graphs
    L = get(handles(i),'children');
    for k=1:length(L)
        s = split(L(k).DisplayName);
        if size(s,1) == 6 && ~df
            set(L(k),'visible','off');
        elseif strcmp(s(5),display_off)
            set(L(k),'visible','off');
        end
    end
end
plotbrowser(h,'on');