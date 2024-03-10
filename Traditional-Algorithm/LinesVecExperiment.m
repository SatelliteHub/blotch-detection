close all
clear

pic = imread('LinesVecExp0001');

% Only two channels because mc only has forward.u and forward.v which ...
% are transferred to rgba.red and rgba.green (see Foundry Nuke)
dx = pic(:,:,1);
dy = pic(:,:,2);
v = sqrt(dx .* dx + dy .* dy);
imshow(v);
