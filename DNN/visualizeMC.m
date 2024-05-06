close all
clear

startFrame = 2;             % Start from 2 if getting from first frame
endFrame = 10;              % Final_Frame - 1
flowSource = 'n';           % 'n' for Nuke and 'r' for RAFT

% For ROC curve
trueLabel = [];
score = [];

for frame = startFrame : endFrame
    % Load frames
    filepath = '~/Documents/MAI Research/Videos/Carrier/Carrier/Carrier%04d.tiff';
    [prevFrameData, currFrameData, nextFrameData, height, width] = loadFrames(frame, filepath);
    
    % Load flow data (Forward Motion then Backward Motion)
    rPath = '';
    nPath = '~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/Nuke/Forward/CarrierForwardLinesVec%04d.tiff';
    [dx_f, dy_f] = loadFlowData(flowSource, frame, '', nPath, height, width);

    rPath = '';
    nPath = '~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/Nuke/Backward/CarrierBackwardLinesVec%04d.tiff';
    [dx_b, dy_b] = loadFlowData(flowSource, frame, '', nPath, height, width);
    
    % Compute Motion Compensation (previous and next)
    I_prev = prevFrameData(:,:,1);
    I_curr = currFrameData(:,:,1);
    I_next = nextFrameData(:,:,1);

    X = ones(height, 1) .* (1:width);
    Y = (1:height)' .* ones(1, width);

    mc_b = interp2(X, Y, I_prev, X+dx_b, Y+dy_b);
    mc_f = interp2(X, Y, I_next, X+dx_f, Y+dy_f);
    
    mc_b(isnan(mc_b)) = 0;
    mc_f(isnan(mc_f)) = 0;

    E_b = I_curr - mc_b;
    E_f = I_curr - mc_f;

    % Save mc_b and mc_f
    mc_b_file = sprintf('~/Documents/MAI Research/Videos/Knight/Knight_Three/Knight_MC/Prev/KN_MC_Prev%04d.tiff', frame);
    mc_f_file = sprintf('~/Documents/MAI Research/Videos/Knight/Knight_Three/Knight_MC/Next/KN_MC_Next%04d.tiff', frame);

    imwrite(mc_b, mc_b_file);
    imwrite(mc_f, mc_f_file);

    % Save E_b and E_f (DPDs)
    E_b_file = sprintf('~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/DPD/Backward/CR_DPD_Prev%04d.tiff', frame);
    E_f_file = sprintf('~/Documents/MAI Research/Videos/Carrier/DPD_Carrier/DPD/Forward/CR_DPD_Next%04d.tiff', frame);
    
    imwrite(E_b, E_b_file);
    imwrite(E_f, E_f_file);
end

