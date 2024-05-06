close all
clear

% Input and output directories
input_directory = '~/Documents/MAI Research/Videos/LinesData/DNN/LDPredictedV9/';
output_directory = '~/Documents/MAI Research/Videos/LinesData/DNN/LDPredictedV9/';

background_height = 1080;
background_width = 1920;

startFrame = 1;
endFrame = 52;

for frame_number = startFrame:endFrame
    % Read input
    input_image = imread(fullfile(input_directory, sprintf('LD_PredictedMask%04d.tiff', frame_number)));
    [input_height, input_width] = size(input_image);

    % Calculate the scaling factor
    scale_factor = min(background_width/input_width, background_height/input_height);

    % Calculate the new dimensions of the resized image
    resized_height = round(input_height * scale_factor);
    resized_width = round(input_width * scale_factor);

    % Resize the image BUT maintain the aspect ratio
    resized_image = imresize(input_image, [resized_height, resized_width]);

    % Create a black background
    background = zeros(background_height, background_width, 'uint8');

    % Calculate the position to center the resized image and insert
    start_row = floor((background_height - resized_height) / 2) + 1;
    start_col = floor((background_width - resized_width) / 2) + 1;
    background(start_row:start_row+resized_height-1, start_col:start_col+resized_width-1) = resized_image;

    % Save
    imwrite(background, fullfile(output_directory, sprintf('LD_PredictedMask%04d.tiff', frame_number)));
end
