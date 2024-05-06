close all
clear

destFilepath = '~/Documents/MAI Research/Videos/Carrier/Small_Carrier/Carrier_Small%04d.tiff';

% New width and height
newWidth = 256;
newHeight = 256;

for i = 1:352
    % Read frames
    imageName = sprintf('~/Documents/MAI Research/Videos/Carrier/Carrier/Carrier%04d.tiff', i);
    originalImage = imread(imageName);
    
    % Resize and save frames
    resizedImage = imresize(originalImage, [newHeight, newWidth]);
    resizedImagePath = sprintf(destFilepath, i);
    imwrite(resizedImage, resizedImagePath);
end
