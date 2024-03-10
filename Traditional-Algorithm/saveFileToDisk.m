function outPath = saveFileToDisk(flag, frame, rOut, nOut)
    switch flag
        case 'r' % RAFT
            outPath = sprintf(rOut, frame);

        case 'n' % Nuke
            outPath = sprintf(nOut, frame);

        otherwise
            error('Invalid flow data source');
    end
end
