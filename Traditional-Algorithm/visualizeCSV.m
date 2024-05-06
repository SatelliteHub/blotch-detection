close all
clear

% Load CSV and set parameters
filename = '~/Documents/MAI Research/Videos/Knight/DPD_Knight/RAFT/Backward/KN_RAFT_Backward0002.csv';
flowData = load(filename);
frameHeight = 256;
frameWidth = 256;

% Extract dx and dy from flow data
dx = flowData(1:frameHeight, 1:frameWidth);
dy = flowData(frameHeight+1:frameHeight*2, 1:frameWidth);

% Convert to grayscale
dxGray = mat2gray(dx);
dyGray = mat2gray(dy);

% RGB image: dx in Red & dy in Green
superimposed = cat(3, dxGray, dyGray, zeros(frameHeight, frameWidth));
figure(1); imshow(superimposed);
title('RAFT Output');
