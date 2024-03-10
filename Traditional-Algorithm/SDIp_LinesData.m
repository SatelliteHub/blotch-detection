close all 
clear

% User Parameters
startFrame = 2; % Start from 2 if getting from first frame
endFrame = 51; % Final_Frame - 1
flowSource = 'r';
filename = 'lines100001.1828x1332.y';
E_t = 0.5;

% Do not change for LinesData
width = 1828;
height = 1332;
numFrames = 52;

for frame = startFrame : endFrame
    % Load frames
    [prevFrameData, currFrameData, nextFrameData] = loadYFile(filename, width, height, frame);

    % Load flow data (Backward Motion then Forward Motion)
    rPath = '~/Documents/MAI Research/Videos/LinesData/LDFlowData/BackwardFlow/LDBackwardFlowData%04d.csv';
    nPath = '~/Documents/MAI Research/Videos/LinesData/LDLineVec/BackwardFlow/LDLinesVecBack%04d.tiff';
    [dx_b, dy_b] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    rPath = '~/Documents/MAI Research/Videos/LinesData/LDFlowData/ForwardFlow/LDForwardFlowData%04d.csv';
    nPath = '~/Documents/MAI Research/Videos/LinesData/LDLineVec/ForwardFlow/LDLinesVecForw%04d.tiff';
    [dx_f, dy_f] = loadFlowData(flowSource, frame, rPath, nPath, height, width);

    % Compute DPD
    [E_b, E_f] = computeDPD(prevFrameData, currFrameData, nextFrameData, dx_f, dy_f, dx_b, dy_b, height, width);

    % Compute SDIp
    bSDIp = (abs(E_b) > E_t) & (abs(E_f) > E_t) & (sign(E_f) == sign(E_b));

    % Save the result
    rDestPath = '~/Documents/MAI Research/Videos/LinesData/SDIp Output/RAFT/SDIp_RAFT%04d.tiff';
    nDestPath = '~/Documents/MAI Research/Videos/LinesData/SDIp Output/Nuke/SDIp_Nuke%04d.tiff';
    destPath = saveFileToDisk(flowSource, frame, rDestPath, nDestPath);
    imwrite(bSDIp, destPath);
end
