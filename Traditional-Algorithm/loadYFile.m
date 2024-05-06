function [prevFrame, currFrame, nextFrame] = loadYFile(filename, width, height, frameIndex)
    fid = fopen(filename, 'r');
    
    % Previous frame (n-1)
    fseek(fid, width * height * (frameIndex - 2), 'bof');
    data = fread(fid, [width * height, 1], 'uchar');
    prevFrame = reshape(data, [width, height])' / 255;

    % Current frame (n)
    fseek(fid, width * height * (frameIndex - 1), 'bof');
    data = fread(fid, [width * height, 1], 'uchar');
    currFrame = reshape(data, [width, height])' / 255;

    % Next frame (n+1)
    fseek(fid, width * height * frameIndex, 'bof');
    data = fread(fid, [width * height, 1], 'uchar');
    nextFrame = reshape(data, [width, height])' / 255;

    fclose(fid);
end

% —————————————————————————————————————————————————————————————————————————
% fseek EXPLNATION
% fseek(fp, offset, origin)

% fp → file pointer

% offset → Number of bytes characters to be offset moved from the current
% file pointer position

% origin → Current file pointer pasition from where offset is added (bof)