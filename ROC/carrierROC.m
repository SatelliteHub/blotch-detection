close all
clear

startFrame = 2;
endFrame = 351;

% Different threshold from SDIp Output
startThresh = 1;
endThresh = 10;

% Differnt version from DNN Output
startVer = 1;
endVer = 7;

% Threshold and Version directories
thresholdDir = cell(startThresh, endThresh);
verDir = cell(startVer, endVer);
for i = startThresh:endThresh
    thresholdDir{i} = sprintf('TSH%02d', i);
end

for i = startVer:endVer
    verDir{i} = sprintf('CR_PredictionsV%d', i);
end


%-----------------------------------


% Compute the TP and FP rates for SDIp (different threshold)
for t = 1:length(thresholdDir)
    for frame = startFrame:endFrame
        % Load SDIp output frames
        prFilepath_SDIp = ['~/Documents/MAI Research/Videos/Carrier/' ...
            'SDIp_Carrier/Nuke/', thresholdDir{t}, '/SDIp_Carrier%04d.tiff'];
        D_SDIp = imread(sprintf(prFilepath_SDIp, frame));

        % Load ground truth frames
        gtFilePath = ['~/Documents/MAI Research/Videos/Carrier/' ...
            'GT_Carrier/GT_Carrier_Binary/GT_Carrier_Binary%04d.tiff'];
        G = imread(sprintf(gtFilePath, frame));

        % Calculate TP and FP rates for SDIp
        TPR_SDIp = sum(sum((D_SDIp == 1) & (G == 1))) / sum(G(:));
        FPR_SDIp = sum(sum((D_SDIp == 1) & (G == 0))) / sum(~G(:));
        TPR_all_SDIp(frame, t) = TPR_SDIp;
        FPR_all_SDIp(frame, t) = FPR_SDIp;
    end
end

% Calculate average TP and FP across all frames for each threshold
avg_TP_SDIp = mean(TPR_all_SDIp);
avg_FP_SDIp = mean(FPR_all_SDIp);

% Display average TP and FP rates foor each threshold
for t = 1:length(thresholdDir)
    disp(['SDIp Threshold ' num2str(t) ':']);
    disp(['Average TP Rate (SDIp): ' num2str(avg_TP_SDIp(t))]);
    disp(['Average FP Rate (SDIp): ' num2str(avg_FP_SDIp(t))]);
    disp(' ');
end


%-----------------------------------


% Compute the TP and FP rates for DNN (different version)
for v = 1:length(verDir)
    for frame = startFrame:endFrame
        % Load DNN Predicted frames
        prFilepath_DNN = ['~/Documents/MAI Research/Videos/Carrier/' ...
            'DNN_Carrier/', verDir{v}, '/CR_PredictedMask%04d.tiff'];
        D_DNN = imread(sprintf(prFilepath_DNN, frame)) / 255;

        % Load ground truth frames
        gtFilePath = ['~/Documents/MAI Research/Videos/Carrier/' ...
            'GT_Carrier/GT_Carrier_Binary/GT_Carrier_Binary%04d.tiff'];
        G = imread(sprintf(gtFilePath, frame));

        % Calculate TP and FP rates for DNN
        TPR_DNN = sum(sum((D_DNN == 1) & (G == 1))) / sum(G(:));
        FPR_DNN = sum(sum((D_DNN == 1) & (G == 0))) / sum(~G(:));
        TPR_all_DNN(frame, v) = TPR_DNN;
        FPR_all_DNN(frame, v) = FPR_DNN;
    end
end

% Calculate average TP and FP across all frames for each version
avg_TP_DNN = mean(TPR_all_DNN);
avg_FP_DNN = mean(FPR_all_DNN);

% Display average TP and FP rates foor each version
for v = 1:length(verDir)
    disp(['DNN Version ' num2str(v) ':']);
    disp(['Average TP Rate (DNN): ' num2str(avg_TP_DNN(v))]);
    disp(['Average FP Rate (DNN): ' num2str(avg_FP_DNN(v))]);
    disp(' ');
end

%---------------------------

% Plot ROC curve with semi-log x-axis and labels
figure(1);
semilogx(avg_FP_SDIp, avg_TP_SDIp, 'r.', 'LineWidth', 2, 'MarkerSize', 15);
hold on;
semilogx(avg_FP_DNN, avg_TP_DNN, 'g.', 'LineWidth', 2, 'MarkerSize', 15);
xlabel('False Positive Rate (FPR)');
ylabel('True Positive Rate (TPR)');
legend('SDIp', 'DNN');
grid on;

% Add labels to data points
for i = 1:length(avg_FP_SDIp)
    text(avg_FP_SDIp(i), avg_TP_SDIp(i), ['T' num2str(i)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end
for i = 1:length(avg_FP_DNN)
    text(avg_FP_DNN(i), avg_TP_DNN(i), ['V' num2str(i)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end

hold off;

% Save plot as EPS file
print -depsc ROC_CR.eps

