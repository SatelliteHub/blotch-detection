close all 
clear

startFrame = 2; % Start from 2 if getting from first frame
endFrame = 51; % Final_Frame - 1
flowSource = 'n';

filename = '~/Documents/MAI Research/Videos/LinesData/lines100001.1828x1332.y';
E_t = 0.08;

% Do not change for LinesData
width = 1828;
height = 1332;
numFrames = 52;

for frame = startFrame : endFrame
    % Load frames
    [prevFrameData, currFrameData, nextFrameData] = loadYFile(filename, width, height, frame);

    % Load flow data (Backward Motion then Forward Motion)
    nPath = '~/Documents/MAI Research/Videos/LinesData/DPD_LinesData/RAFT/Backward/LDLinesVecBack%04d.tiff';
    rPath = '~/Documents/MAI Research/Videos/LinesData/DPD_LinesData/RAFT/Backward/LDForwardFlowData%04d.csv';
    [dx_b, dy_b] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    nPath = '~/Documents/MAI Research/Videos/LinesData/DPD_LinesData/Nuke/Forward/LDLinesVecForw%04d.tiff';
    rPath = '~/Documents/MAI Research/Videos/LinesData/DPD_LinesData/Nuke/Forward/LDBackwardFlowData%04d.csv';
    [dx_f, dy_f] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    % Compute DPD
    [E_b, E_f] = computeDPD(prevFrameData, currFrameData, nextFrameData, dx_f, dy_f, dx_b, dy_b, height, width);

    % Compute SDIp
    bSDIp = (abs(E_b) > E_t) & (abs(E_f) > E_t) & (sign(E_f) == sign(E_b));

    % Save the result
    nDestPath = '~/Documents/MAI Research/Videos/LinesData/SDIp Output/Nuke/TSH10/LD_SDIp_Nuke%04d.tiff';
    rDestPath = '~/Documents/MAI Research/Videos/LinesData/SDIp Output/RAFT/TSH08/LD_SDIp_RAFT%04d.tiff';
    destPath = saveFileToDisk(flowSource, frame, rDestPath, nDestPath);
    imwrite(bSDIp, destPath);
end
