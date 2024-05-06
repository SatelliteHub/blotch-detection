close all
clear

startFrame = 2;             % Start from 2 if getting from first frame
endFrame = 63;              % Final_Frame - 1
flowSource = 'n';           % 'n' for Nuke and 'r' for RAFT
E_t = 1;                   % Threshold

for frame = startFrame : endFrame
    % Load frames
    filepath = '~/Documents/MAI Research/Videos/Knight/Knight/Knight%04d.tiff';
    [prevFrameData, currFrameData, nextFrameData, height, width] = loadFrames(frame, filepath);
    
    % Load flow data (Forward Motion then Backward Motion)
    nPath = '~/Documents/MAI Research/Videos/Knight/DPD_Knight/Nuke/Forward/NukeDPDForward%04d.tiff';
    rPath = '~/Documents/MAI Research/Videos/Knight/DPD_Knight/RAFT/Forward/KN_RAFT_Forward%04d.csv';
    [dx_f, dy_f] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    nPath = '~/Documents/MAI Research/Videos/Knight/DPD_Knight/Nuke/Backward/NukeDPDBackward%04d.tiff';
    rPath = '~/Documents/MAI Research/Videos/Knight/DPD_Knight/RAFT/Backward/KN_RAFT_Backward%04d.csv';
    [dx_b, dy_b] = loadFlowData(flowSource, frame, rPath, nPath, height, width);
    
    % Compute DPD
    [E_b, E_f] = computeDPD(prevFrameData, currFrameData, nextFrameData, dx_f, dy_f, dx_b, dy_b, height, width);
    
    % Compute SDIp
    bSDIp = (abs(E_b) > E_t) & (abs(E_f) > E_t) & (sign(E_f) == sign(E_b));
   
    % Save the result
    nDestPath = '~/Documents/MAI Research/Videos/Knight/SDIp_Knight/Nuke/TSH10/SDIp_Knight%04d.tiff';
    rDestPath = '~/Documents/MAI Research/Videos/Knight/SDIp_Knight/RAFT/TSH09/SDIp_Knight%04d.tiff';
    destPath = saveFileToDisk(flowSource, frame, rDestPath, nDestPath);
    imwrite(bSDIp, destPath);
end

