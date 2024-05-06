close all
clear

startFrame = 2;             % Start from 2 if getting from first frame
endFrame = 351;              % Final_Frame - 1
flowSource = 'n';           % 'n' for Nuke and 'r' for RAFT
E_t = 0.1;                   % Threshold


for frame = startFrame : endFrame
    % Load frames
    filepath = '~/Documents/MAI Research/Videos/Carrier/Carrier/Carrier%04d.tiff';
    [prevFrameData, currFrameData, nextFrameData, height, width] = loadFrames(frame, filepath);
    
    % Load flow data (Forward Motion then Backward Motion)
    nPath = '~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/Nuke/Forward/CarrierForwardLinesVec%04d.tiff';
    rPath = '~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/RAFT/Forward/CarrierForwardFlowData%04d.csv';
    [dx_f, dy_f] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    nPath = '~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/Nuke/Backward/CarrierBackwardLinesVec%04d.tiff';
    rPath = '~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/RAFT/Backward/CarrierBackwardFlowData%04d.csv';
    [dx_b, dy_b] = loadFlowData(flowSource, frame, rPath, nPath, height, width);
    
    % Compute DPD
    [E_b, E_f] = computeDPD(prevFrameData, currFrameData, nextFrameData, dx_f, dy_f, dx_b, dy_b, height, width);
    
    % Compute SDIp
    bSDIp = (abs(E_b) > E_t) & (abs(E_f) > E_t) & (sign(E_f) == sign(E_b));
   
    % Save the result
    nDestPath = '~/Documents/MAI Research/Videos/Carrier/SDIp_Carrier/Nuke/TSH10/SDIp_Carrier%04d.tiff';
    rDestPath = '~/Documents/MAI Research/Videos/Carrier/SDIp_Carrier/RAFT/TSH5/SDIp_Carrier%04d.tiff';
    destPath = saveFileToDisk(flowSource, frame, rDestPath, nDestPath);
    imwrite(bSDIp, destPath);
end

