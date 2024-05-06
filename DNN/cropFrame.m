close all
clear

% Define input and output directories
input_directory = '~/Documents/MAI Research/Videos/LinesData/GT_LinesData/GT_LinesData_Binary/';
output_directory = '~/Documents/MAI Research/Videos/LinesData/GT_LinesData/GT_LD_Crop/';

% Define square size
square_size = [320, 240];

for i = 1:352
    % Generate the file name, read image, and get dimensions
    file_number = sprintf('%04d', i);
    filename = strcat('GT_LinesData_Binary', file_number, '.tiff');
    input_path = fullfile(input_directory, filename);
    
    image = imread(input_path);
    [height, width, ~] = size(image);
    
    % Calculate padding sizes
    pad_height = mod(-height, square_size(2));
    pad_width = mod(-width, square_size(1));
    
    % Pad the image with black pixels if needed
    if pad_height > 0 || pad_width > 0
        image = padarray(image, [pad_height, pad_width], 0, 'post');
        height = height + pad_height;
        width = width + pad_width;
    end
    
    [num_rows, num_cols] = divide_into_squares(width, height, square_size);
    
    % Split the image into squares
    for row = 1:num_rows
        for col = 1:num_cols
            % Calculate the indices for the current square
            start_row = (row - 1) * square_size(2) + 1;
            end_row = min(row * square_size(2), height);
            start_col = (col - 1) * square_size(1) + 1;
            end_col = min(col * square_size(1), width);
            
            % Extract the current square
            square = image(start_row:end_row, start_col:end_col, :);
            
            % Save the current square
            output_filename = sprintf('GT_LinesData_Binary%s_Crop%02d.tiff', file_number, (row - 1) * num_cols + col);
            output_path = fullfile(output_directory, output_filename);
            imwrite(square, output_path);
        end
    end
end

function [num_rows, num_cols] = divide_into_squares(width, height, square_size)
    % Calculate number of rows and columns of squares
    num_rows = floor(height / square_size(2));
    num_cols = floor(width / square_size(1));
end
