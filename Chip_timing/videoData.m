classdef videoData
    %videoData is a holder for all videos taken of the chip
    %   it also holds the most recent crops
    
    properties
        %matrix of video data
        videoMatrix
        framerateMatrix
        
        %matrix of crop positioning
        cropMatrix
        
        %video directory
        vid_dir = 'C:\Users\alex\Documents\FC_videos\AmScope';
        video_ext = '.avi';
        RAM_dir = 'R:\';
        
    end
    
    methods
        function V = videoData(vidMat, cropMat, frameMat)
            %video stores the data of all videos for chip
            
            V.videoMatrix =  vidMat;
            V.cropMatrix = cropMat;
            V.framerateMatrix = frameMat;
        end
        
        function path = video_path(V,location)
           filename = char(V.videoMatrix(location(1),location(2)));
           if isfile([V.RAM_dir '\' filename])
              copyfile([V.RAM_dir '\' filename]);
              delete([V.RAM_dir '\' filename]);
           end
           path = [V.vid_dir '\' filename];
        end
        
    end
end

