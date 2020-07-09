cd('C:\Users\alex\Documents\AmScope')
%%
vidObj = VideoReader('200116164818.mp4');

time_diff=zeros(50,1);
old_time = 0;
current_time=zeros(50,1);
for i=1:vidObj.numFrames
    frame = read(v,i);
    time_diff(i) = v.CurrentTime - old_time;
    current_time(i) = v.CurrentTime;
    old_time = v.CurrentTime;
end
figure(1);
plot(time_diff)
figure(2);
plot(current_time)
%%
vidObj = VideoReader('200116154544.mp4');
old_time = 0;
i=1;
vidObj.numFrames
while(hasFrame(vidObj))
    frame = readFrame(vidObj);
%     imshow(frame);
%     title(sprintf('Current Time = %.3f sec', vidObj.CurrentTime));
%     pause(2/vidObj.FrameRate);
    sprintf('Current Time = %.3f sec', vidObj.CurrentTime);
    time_diff(i) = vidObj.CurrentTime - old_time;
    old_time = v.CurrentTime;
    i=i+1;
end
figure(1);
plot(time_diff)

%%
close all
vidObj = VideoReader('200117095838.mp4');
while(hasFrame(vidObj))
    frame = readFrame(vidObj);
    imshow(frame);
    title(sprintf('Current Time = %.3f sec', vidObj.CurrentTime));
    input(['Press enter'],'s')
end