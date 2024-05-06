function [dx, dy] = loadFlowData(flag, frame, rIn, nIn, frameHeight, frameWidth)
    switch flag
        case 'r' % RAFT
            filename = sprintf(rIn, frame);
            flowData = load(filename);
            dx = flowData(1 : frameHeight, 1 : frameWidth);
            dy = flowData(frameHeight+1 : frameHeight*2, 1 : frameWidth);

        case 'n' % Nuke
            filename = sprintf(nIn, frame);
            flowData = imread(filename);
            dx = flowData(:,:,1);
            dy = -flowData(:,:,2);

        otherwise
            error('Invalid flow data source');
    end
end
