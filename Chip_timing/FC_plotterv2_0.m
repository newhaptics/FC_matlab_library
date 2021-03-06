%% Enter the required directories and create desired variables
vid_dir = 'C:\Users\alex\Documents\FC_videos\AmScope';
file_dir = 'C:\Users\alex\Dropbox\FC_matlab_library';
graph_dir = 'C:\Users\alex\Dropbox\FC_Graphs';
RAM_dir = 'R:\';

cd(graph_dir);
addpath(vid_dir);
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
display_off = '2';
select = 0;
compareList = {'[1 1]','[2 1]','[3 1]','[4 1]','[5 1]'};

%% raw pulse data
h = openfig([FC.model 'fig1']);
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
            delete(L(k));
        elseif strcmp(s(5),display_off)
            delete(L(k));
        elseif ~(sum(strcmp([char(s(2)) ' ' char(s(3))],compareList)) >= 1) && select
            delete(L(k));
        end
    end
end
plotbrowser(h,'on');



%% gate pulse data
h = openfig([FC.model 'fig2']);
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
            delete(L(k));
        elseif strcmp(s(5),display_off)
            delete(L(k));
        elseif ~(sum(strcmp([char(s(2)) ' ' char(s(3))],compareList)) >= 1) && select
            delete(L(k));
        end
    end
end
plotbrowser(h,'on');

%% raw pulse not aligned data
h = openfig([FC.model 'fig3']);
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
            delete(L(k));
        elseif strcmp(s(5),display_off)
            delete(L(k));
        elseif ~(sum(strcmp([char(s(2)) ' ' char(s(3))],compareList)) >= 1) && select
            delete(L(k));
        end
    end
end
plotbrowser(h,'on');


%%
FC.generate_timingData(1)