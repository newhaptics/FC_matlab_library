function [avgBright] = average_brightness(posMatrix, video)
% average brightness cycles through each frame in the video and for each
% frame calculates the mean brightnes in each crop of the video

%find the start and end frame
num_frames = video.NumberOfFrames;
start_frame=1;
end_frame=num_frames;

% load([vid_dir '/' filename '.mat']);
% Determine number of frames and define grayscalematrix and time
total_frames=end_frame-start_frame;

% outputs is rows of posMatrix
outputs = size(posMatrix,1);

% Define brightness matrix
avgBright = zeros(total_frames,outputs);

% % Iterate through frames calculate average brigtness for each region
% x=0; % create variable to track progress of program


for i = 1:total_frames

   currentTime = (i-1)*(1/(16*video.framerate));
   this_frame = read(video,start_frame-1+i);
   this_frame = rgb2gray(this_frame);
   
   for j=1:outputs
        avgBright(i,j)=mean2(imcrop(this_frame,posMatrix(j,:)));
   end
end
end

