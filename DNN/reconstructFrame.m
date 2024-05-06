% Define input and output directories
input_directory = '~/Downloads/CR_Predictions/';
output_directory = '~/Documents/MAI Research/Videos/Carrier/DNN_Carrier/CR_PredictionsV8/';

% Define Square size
square_size = [320, 240];

for file_number = 1:352
    % Set number of rows and columns
    num_rows = 5;
    num_cols = 6;
    % reconstructed_image = zeros(num_rows * squa`re_size(2), num_cols * square_size(1), 3, 'uint8');
    reconstructed_image = zeros(num_rows * square_size(2), num_cols * square_size(1), 'uint8'); 

    for row = 1:num_rows
        for col = 1:num_cols
            filename = sprintf('CR_PredictedMask%04d_Crop%02d.tif', file_number, (row - 1) * num_cols + col);
            input_path = fullfile(input_directory, filename);
            cropped_frame = imread(input_path);

            % Calculate the indices for placing the cropped frame in the reconstructed image
            start_row = (row - 1) * square_size(2) + 1;
            end_row = row * square_size(2);
            start_col = (col - 1) * square_size(1) + 1;
            end_col = col * square_size(1);

            % Place the cropped frame in the reconstructed image
            % reconstructed_image(start_row:end_row, start_col:end_col, :) = cropped_frame;
            reconstructed_image(start_row:end_row, start_col:end_col) = cropped_frame;
        end
    end

    % Crop the reconstructed image
    x = 1;
    y = 1;
    width = 1920;
    height = 1080;
    reconstructed_image = imcrop(reconstructed_image, ...
        [x, y, width-1, height-1]); % Subtract 1 from width and height to account for 0-based indexing

    % Save the reconstructed image
    output_filename = sprintf('CR_PredictedMask%04d.tiff', file_number);
    output_path = fullfile(output_directory, output_filename);
    imwrite(reconstructed_image, output_path);
end
