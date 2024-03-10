close all
clear

% %% LinesVec
% pic = imread('LinesVecExp0001');
% 
% % Only two channels because mc only has forward.u and forward.v which ...
% % are transferred to rgba.red and rgba.green (see Foundry Nuke)
% dx = pic(:,:,1);
% dy = pic(:,:,2);
% v = sqrt(dx .* dx + dy .* dy);
% imshow(v);
% 
% %% Zeros and Ones
% firstImage = imread('carrier_numbered/carrier0001.tif');
% [height, width, ~] = size(firstImage);
% 
% N = 3;
% M = 3;
% 
% H = ((0:N-1)' .* ones(1, M))'
% K = (0:N-1)' .* ones(1, M)
% 
% %% RAW TIFF File (Read and Display)
% 
% t = Tiff('CarrierLinesVec0001', 'r'); 
% img = read(t); 
% close(t);
% imshow(img);
% 
% %% Rose
% 
% n = 800;
% A = 1.995653;
% B = 1.27689;
% C = 8;
% r=linspace(0,1,n);
% theta=linspace(-2,20*pi,n);
% [R,THETA]=ndgrid(r,theta);
% % define the number of petals we want per cycle. Roses have 3 and a bit.
% petalNum=3.6;
% x = 1 - (1/2)*((5/4)*(1 - mod(petalNum*THETA, 2*pi)/pi).^2 - 1/4).^2;
% phi = (pi/2)*exp(-THETA/(C*pi));
% y = A*(R.^2).*(B*R - 1).^2.*sin(phi);
% R2 = x.*(R.*sin(phi) + y.*cos(phi));
% X=R2.*sin(THETA);
% Y=R2.*cos(THETA);
% Z=x.*(R.*cos(phi)-y.*sin(phi));
% % % define a red map for our rose colouring
% red_map=linspace(1,0.25,10)';
% red_map(:,2)=0;
% red_map(:,3)=0;
% clf
% surf(X,Y,Z,'LineStyle','none')
% view([-40.50 42.00])
% colormap(red_map)
% 
% %% Quiver Test
% 
% frameNumber = 2;
% flowSource = 'r';
% 
% filename = sprintf('carrier_numbered/carrier%04d.tif', frameNumber);
% frame = imread(filename);
% 
% [height, width, ~] = size(imread('carrier_numbered/carrier0001.tif'));
% 
% step = 50;
% [x, y] = meshgrid(1:step:width, 1:step:height);
% 
% rPath = sprintf('~/Documents/MAI Research/Videos/Carrier/CarrierFlowData/flow_data_%04d.csv', frameNumber);
% nPath = sprintf('~/Documents/MAI Research/Videos/Carrier/CarrierLinesVec/CarrierLinesVec%04d', frameNumber);
% [fdx, fdy] = loadFlowData(flowSource, frameNumber, rPath, nPath, height, width);
% 
% figure; 
% imshow(frame);
% hold on;
% quiver(x, y, fdx(1:step:end, 1:step:end), fdy(1:step:end, 1:step:end), 0, 'r-', 'linewidth', 1);
% hold off;

%% Combine 3 Frames to 1 Frame using RGB

frame1 = imread('carrier_numbered/carrier0001.tif');
frame2 = imread('carrier_numbered/carrier0002.tif');
frame3 = imread('carrier_numbered/carrier0003.tif');

% Extract individual RGB channels from each frame
R = frame1(:,:,1);
G = frame2(:,:,2);
B = frame3(:,:,3);

% Combine the channels to create one single frame
combined_image = cat(3, R, G, B);

% Display the combined image
imshow(combined_image);

