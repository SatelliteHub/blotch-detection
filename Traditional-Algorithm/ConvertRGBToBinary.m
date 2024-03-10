close all 
clear

for i = 26:26
  
  % Read grayscale image
  filename = sprintf('~/Documents/MAI Research/Videos/Carrier/GroundTruth/gt_carrier%04d.tiff', i);
  rgb_image = imread(filename);
  gray_image = im2gray(rgb_image);

  % Convert to binary mask 
  threshold = 0.5;
  binary_image = gray_image > threshold;

  % Save binary mask
  output_filename = sprintf('~/Documents/MAI Research/Videos/Carrier/GroundTruth/gt_carrier_binary%04d.tiff', i);
  imwrite(binary_image, output_filename, 'tiff');

end

