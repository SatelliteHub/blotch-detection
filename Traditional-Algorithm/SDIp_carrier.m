close all
clear

% User Parameters
startFrame = 2; % Start from 2 if getting from first frame
endFrame = 351; % Final_Frame - 1
flowSource = 'n';
E_t = 0.5;

for frame = startFrame : endFrame
    % Load frames
    filepath = 'carrier_numbered/carrier%04d.tif';
    [prevFrameData, currFrameData, nextFrameData, height, width] = loadFrames(frame, filepath);
    
    % Load flow data (Forward Motion then Backward Motion)
    rPath = '~/Documents/MAI Research/Videos/Carrier/CarrierFlowData/ForwardFlow/CarrierForwardFlowData%04d.csv';
    nPath = '~/Documents/MAI Research/Videos/Carrier/CarrierLinesVec/ForwardFlow/CarrierForwardLinesVec%04d.tiff';
    [dx_f, dy_f] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    rPath = '~/Documents/MAI Research/Videos/Carrier/CarrierFlowData/BackwardFlow/CarrierBackwardFlowData%04d.csv';
    nPath = '~/Documents/MAI Research/Videos/Carrier/CarrierLinesVec/BackwardFlow/CarrierBackwardLinesVec%04d.tiff';
    [dx_b, dy_b] = loadFlowData(flowSource, frame, rPath, nPath, height, width);
    
    % Compute DPD
    [E_b, E_f] = computeDPD(prevFrameData, currFrameData, nextFrameData, dx_f, dy_f, dx_b, dy_b, height, width);
    
    % Compute SDIp
    bSDIp = (abs(E_b) > E_t) & (abs(E_f) > E_t) & (sign(E_f) == sign(E_b));
    
    % Save the result
    rDestPath = '~/Documents/MAI Research/Videos/Carrier/SDIp Output/RAFT/SDIp_RAFT%04d.tiff';
    nDestPath = '~/Documents/MAI Research/Videos/Carrier/SDIp Output/Nuke/SDIp_Nuke%04d.tiff';
    destPath = saveFileToDisk(flowSource, frame, rDestPath, nDestPath);
    imwrite(bSDIp, destPath);
end

