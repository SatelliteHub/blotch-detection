function [prevFrameData, currFrameData, nextFrameData, h, w] = loadFrames(frame, filepath)
    % Get height and width of the frames
    firstImage = imread(sprintf(filepath, 1));
    [h, w, ~] = size(firstImage);
    
    % Load previous frame
    filename_prev = sprintf(filepath, frame-1);
    img_prev = imread(filename_prev);
    prevFrameData = double(img_prev) / 255;
    
    % Load current frame
    filename_curr = sprintf(filepath, frame);
    img_curr = imread(filename_curr);
    currFrameData = double(img_curr) / 255;
    
    % Load next frame
    filename_next = sprintf(filepath, frame+1);
    img_next = imread(filename_next);
    nextFrameData = double(img_next) / 255;
end
