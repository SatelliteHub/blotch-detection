close all
clear

frameNumber = 4;
flowSource = 'r';

filename = sprintf('~/Documents/MAI Research/Videos/Carrier/Carrier/Carrier%04d.tiff', frameNumber);
frame = imread(filename);

[height, width, ~] = size(imread('~/Documents/MAI Research/Videos/Carrier/Carrier/Carrier0001.tiff'));

step = 50;
[x, y] = meshgrid(1:step:width, 1:step:height);

% rpath = sprintf('~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/RAFT/Forward/CarrierForwardFlowData%04d.csv', frameNumber);
% nPath = sprintf('~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/Nuke/Forward/CarrierForwardLinesVec%04d.tiff', frameNumber);

rpath = sprintf('~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/RAFT/Backward/CarrierBackwardFlowData%04d.csv', frameNumber);
nPath = sprintf('~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/Nuke/Backward/CarrierBackwardLinesVec%04d.tiff', frameNumber);

[fdx, fdy] = loadFlowData(flowSource, frameNumber, rpath, nPath, height, width);


outputImage = insertQuiverPlot(frame, fdx, fdy, step);
outputFilename = sprintf('~/Downloads/Carrier_Quiver%04d.tiff', frameNumber);
imwrite(outputImage, outputFilename);


% Insert quiver plot onto the frame
function outputImage = insertQuiverPlot(frame, fdx, fdy, step)
    [height, width, ~] = size(frame);
    [x, y] = meshgrid(1:step:width, 1:step:height);

    % Plot quiver onto a new figure
    figure;
    imshow(frame);
    hold on;
    quiver(x, y, fdx(1:step:end, 1:step:end), fdy(1:step:end, 1:step:end), 0, 'r-', 'linewidth', 1);
    hold off;

    % Capture the plotted figure into an image
    f = getframe(gca);
    outputImage = f.cdata;
end
