close all 
clear

for i = 1 : 52
  % Read image
  filename = sprintf(['~/Documents/MAI Research/Videos/LinesData/' ...
      'GT_LinesData/GT_LinesData/GT_LinesData%04d.tiff'], i);
  gray_image = imread(filename);
  
  % Check image type and convert if necessary
  switch size(gray_image, 3)
      case 1
          % Image is already grayscale
      case 3
          % Image is RGB, convert to grayscale
          gray_image = rgb2gray(gray_image);
      otherwise
          error('Image neither 1 or 3 channels');
  end

  % Convert to binary mask 
  threshold = 0.5;
  binary_image = gray_image > threshold;

  % Save binary mask
  output_filename = sprintf(['~/Documents/MAI Research/Videos/LinesData/' ...
      'GT_LinesData/GT_LinesData_Binary/GT_LinesData_Binary%04d.tiff'], i);
  imwrite(binary_image, output_filename, 'tiff');

end
