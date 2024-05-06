close all
clear

height = 256; 
width = 256;

startFrame = 1;
endFrame = 63;
z = zeros(height, width, 3);

source = 'non-mc'; % 'mc' for motion-compensated & 'non-mc' for non-motion-compensated

if strcmp(source, 'mc') % 2 for non-MC and 3 for MC when starting from 1st
    startFrame = startFrame + 2;
elseif strcmp(source, 'non-mc')
    startFrame = startFrame + 1;
end

for i = startFrame:endFrame
    switch lower(source)
        case 'mc'
            % MC path
            prevFrame = imread(sprintf('~/Documents/MAI Research/Videos/Knight/Knight_Three/Knight_MC/Prev/KN_MC_Prev%04d.tiff', i-1));
            % IF RGB, WRITE rgb2gray(____)
            currFrame = rgb2gray(imread(sprintf('~/Documents/MAI Research/Videos/Knight/Knight/Knight%04d.tiff', i)));
            nextFrame = imread(sprintf('~/Documents/MAI Research/Videos/Knight/Knight_Three/Knight_MC/Next/KN_MC_Next%04d.tiff', i+1));
        case 'non-mc'
            % Non-MC path (IF RGB, WRITE rgb2gray(____))
            prevFrame = rgb2gray(imread(sprintf('~/Documents/MAI Research/Videos/Knight/Knight/Knight%04d.tiff', i - 1)));
            currFrame = rgb2gray(imread(sprintf('~/Documents/MAI Research/Videos/Knight/Knight/Knight%04d.tiff', i)));
            nextFrame = rgb2gray(imread(sprintf('~/Documents/MAI Research/Videos/Knight/Knight/Knight%04d.tiff', i + 1)));
        otherwise
            error('Invalid source specified. Use ''mc'' for motion-compensated or ''non-mc'' for non-motion-compensated.');
    end

    % Subtraction of current, previous, and next frame
    R = currFrame - prevFrame + 128;
    G = currFrame;
    B = currFrame - nextFrame + 128;
    
    % Combine the channels to create one single frame
    z(:,:,1) = R;
    z(:,:,2) = G;
    z(:,:,3) = B;

    % Save as TIFF based on source type
    switch lower(source)
        case 'mc'
            tiffname = sprintf(['~/Documents/MAI Research/Videos/' ...
                'Knight/Knight_Three/Knight_Three_MC/Knight_Three_MC%04d.tiff'], i);
        case 'non-mc'
            tiffname = sprintf(['~/Documents/MAI Research/Videos/' ...
                'Knight/Knight_Three/Knight_Three/Knight_Three%04d.tiff'], i);
    end
    imwrite(uint8(z), tiffname);
end
