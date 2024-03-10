function [fdx, fdy, dest_filename] = flowDataFunction(dataSource, frame)
    switch dataSource
        case 'r' % RAFT
            filename = sprintf(['~/Documents/MAI Research/Videos/' ...
                'Carrier/CarrierFlowData/flow_data_%04d.csv'], frame);
            flowData = load(filename);
            fdx = flowData(1:1080, :);
            fdy = flowData(1081:end, :);
            dest_filename = sprintf(['~/Documents/MAI Research/Videos/' ...
                'Carrier/MC Carrier MATLAB/RAFT/MCCarrierRAFT%04d.png'], frame);

        case 'n' % Nuke
            filename = sprintf(['~/Documents/MAI Research/Videos/' ...
                'Carrier/CarrierLinesVec/CarrierLinesVec%04d'], frame);
            flowData = imread(filename);
            fdx = flowData(:,:,1);
            fdy = flowData(:,:,2);
            dest_filename = sprintf(['~/Documents/MAI Research/Videos/' ...
                'Carrier/MC Carrier MATLAB/Nuke/MCCarrierNuke%04d.png'], frame);

        otherwise
            error('Invalid flow data source');
    end
end
