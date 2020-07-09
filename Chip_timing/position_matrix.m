function [posMatrix] = position_matrix(video, name)
% position_matrix takes in a video and uses the first frame to allow user
% to select the regions which will collect the data for brightness

outputs = length(name);

% Read in frame 1 and show
this_frame = read(video,400);
this_frame = rgb2gray(this_frame); %convert to grayscale
thisfig = figure(1);
imshow(this_frame);

posMatrix=zeros(outputs,4);
% posMatrixCrops=zeros(outputs,4,5); % max of five interior crop regions
% num_crop_regions=zeros(length(outputs),1);

for i=1:outputs
    %for outputs that are not electronic
    if ~contains(name(i),'electronic')
        clear reg
        close(thisfig)
        thisfig = figure(1);
        imshow(this_frame);
        disp(['For region: ' name(i)]);
        
        [reg,posMatrix(i,:)]= imcrop(this_frame);
    end
    %% For making multiple crop regions per area of interest
    %     num_crop_regions(i,1)=input('Enter the number of cropped regions: ');
    %
    %     for j=1:num_crop_regions(i,1)
    %         clear crop
    %         close(thisfig)
    %         thisfig = figure(1);
    %         imshow(reg);
    %         [crop,posMatrixCrops(i,:,j)]= imcrop(reg);
    %     end
    
end
close all;

end

