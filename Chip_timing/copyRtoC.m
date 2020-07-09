clear all

chip_version = 'M3AR_1';

vid_dir = 'C:\Users\NewHapticsUser2\Documents\AmScope';
RAM_dir = 'R:\';
am_dir = 'C:\Users\alex\Dropbox\Chip Timing\Results';

cd(vid_dir)
addpath(RAM_dir)
addpath(am_dir)

video_ext = '.avi';

filenames = dir([RAM_dir chip_version '*' video_ext]);

for i = [1 2]
    file = filenames(i).name;
    newfilename = [erase(file,video_ext) '_' datestr(now,30) video_ext];
    if isfile([RAM_dir '/' file])
        copyfile([RAM_dir '/' file],newfilename);
        delete([RAM_dir '/' file]);
    end
end

% datestr(now,30)

%% copy from lab computer to DJ's computer

clear all

chip_version = 'M3AR_1';

vid_dir = '\\DESKTOP-5N614CS\Users\NewHapticsUser2\Documents\AmScope\';
am_dir = 'C:\Users\alex\Documents\FC_videos\AmScope';

cd(am_dir)
addpath(vid_dir)

video_ext = '.avi';

filenames = dir([vid_dir chip_version '*' video_ext]);

for i  = 1:length(filenames)
    file = filenames(i).name;
    newfilename = [erase(file,video_ext) '_' datestr(now,30) video_ext];
    if isfile([vid_dir '/' file])
        copyfile([vid_dir '/' file],newfilename);
        delete([vid_dir '/' file]);
    end
end