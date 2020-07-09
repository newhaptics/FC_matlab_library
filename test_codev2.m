obj = VideoReader('200122194947-1.m4v');
framecount = 0;
while hasFrame(obj)
    readFrame(obj);
    framecount = framecount +1;
    current_time(framecount) = obj.currenttime;
end
ueotuaeouetnsohsan
