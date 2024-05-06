close all
clear

startFrame_CR = 2;
endFrame_CR = 351;

startFrame_LD = 2;
endFrame_LD = 51;

startFrame_KN = 2;
endFrame_KN = 63;

% Different threshold from SDIp Output
startThresh = 1;
endThresh = 10;

% Differnt version from DNN Output
startVer = 1;
endVer = 7;

% Define threshold directories
thresholdDir = cell(startThresh, endThresh);
verDir = cell(startVer, endVer);
for i = startThresh:endThresh
    thresholdDir{i} = sprintf('TSH%02d', i);
end

for i = startVer:endVer
    verDir{i} = sprintf('CR_PredictionsV%d', i);
end


%-----------------------------------


% CR: Compute the TP and FP rates for SDIp (different threshold)
for t = 1:length(thresholdDir)
    for frame = startFrame_CR:endFrame_CR
        % Load SDIp output frames
        prFilepath_SDIp = ['~/Documents/MAI Research/Videos/Carrier/' ...
            'SDIp_Carrier/Nuke/', thresholdDir{t}, '/SDIp_Carrier%04d.tiff'];
        D_SDIp = imread(sprintf(prFilepath_SDIp, frame));

        % Load ground truth frames
        gtFilePath = ['~/Documents/MAI Research/Videos/Carrier/' ...
            'GT_Carrier/GT_Carrier_Binary/GT_Carrier_Binary%04d.tiff'];
        G = imread(sprintf(gtFilePath, frame));

        % Calculate TP and FP rates for SDIp
        TPR_SDIp_CR = sum(sum((D_SDIp == 1) & (G == 1))) / sum(G(:));
        FPR_SDIp_CR = sum(sum((D_SDIp == 1) & (G == 0))) / sum(~G(:));
        TPR_all_SDIp_CR(frame, t) = TPR_SDIp_CR;
        FPR_all_SDIp_CR(frame, t) = FPR_SDIp_CR;
    end
end

% Calculate average TP and FP across all frames for each threshold
avg_TP_SDIp_CR = mean(TPR_all_SDIp_CR);
avg_FP_SDIp_CR = mean(FPR_all_SDIp_CR);

% Display average TP and FP rates foor each threshold
for t = 1:length(thresholdDir)
    disp(['SDIp Threshold ' num2str(t) ':']);
    disp(['Average TP Rate (SDIp): ' num2str(avg_TP_SDIp_CR(t))]);
    disp(['Average FP Rate (SDIp): ' num2str(avg_FP_SDIp_CR(t))]);
    disp(' ');
end


%-----------------------------------

% LD: Compute the TP and FP rates for SDIp (different threshold)
for t = 1:length(thresholdDir)
    for frame = startFrame_LD:endFrame_LD
        % Load SDIp output frames
        prFilepath_SDIp = ['~/Documents/MAI Research/Videos/LinesData/' ...
            'SDIp_LinesData/Nuke/', thresholdDir{t}, '/LD_SDIp_Nuke%04d.tiff'];
        D_SDIp = imread(sprintf(prFilepath_SDIp, frame));

        % Load ground truth frames
        gtFilePath = ['~/Documents/MAI Research/Videos/LinesData/' ...
            'GT_LinesData/GT_LinesData_Binary/GT_LinesData_Binary%04d.tiff'];
        G = imread(sprintf(gtFilePath, frame));

        % Check if the ground truth image is all zeros
        if all(G(:) == 0)
            continue; % Skip this frame
        end

        % Calculate TP and FP rates for SDIp
        TPR_SDIp_LD = sum(sum((D_SDIp == 1) & (G == 1))) / sum(G(:));
        FPR_SDIp_LD = sum(sum((D_SDIp == 1) & (G == 0))) / sum(~G(:));
        TPR_all_SDIp_LD(frame, t) = TPR_SDIp_LD;
        FPR_all_SDIp_LD(frame, t) = FPR_SDIp_LD;
    end
end

% Calculate average TP and FP across all frames for each threshold
avg_TP_SDIp_LD = mean(TPR_all_SDIp_LD);
avg_FP_SDIp_LD = mean(FPR_all_SDIp_LD);

% Display average TP and FP rates foor each threshold
for t = 1:length(thresholdDir)
    disp(['SDIp Threshold ' num2str(t) ':']);
    disp(['Average TP Rate (SDIp): ' num2str(avg_TP_SDIp_LD(t))]);
    disp(['Average FP Rate (SDIp): ' num2str(avg_FP_SDIp_LD(t))]);
    disp(' ');
end


%---------------------------

% KN: Compute the TP and FP rates for SDIp (different threshold)
for t = 1:length(thresholdDir)
    for frame = startFrame_KN:endFrame_KN
        % Load SDIp output frames
        prFilepath_SDIp = ['~/Documents/MAI Research/Videos/Knight/' ...
            'SDIp_Knight/Nuke/', thresholdDir{t}, '/SDIp_Knight%04d.tiff'];
        D_SDIp = imread(sprintf(prFilepath_SDIp, frame));

        % Load ground truth frames
        gtFilePath = ['~/Documents/MAI Research/Videos/Knight/' ...
            'GT_Knight/GT_Knight_Binary/GT_Knight_Binary%04d.tiff'];
        G = imread(sprintf(gtFilePath, frame));

        % Check if the ground truth image is all zeros
        if all(G(:) == 0)
            continue; % Skip this frame
        end

        % Calculate TP and FP rates for SDIp
        TPR_SDIp_KN = sum(sum((D_SDIp == 1) & (G == 1))) / sum(G(:));
        FPR_SDIp_KN = sum(sum((D_SDIp == 1) & (G == 0))) / sum(~G(:));
        TPR_all_SDIp_KN(frame, t) = TPR_SDIp_KN;
        FPR_all_SDIp_KN(frame, t) = FPR_SDIp_KN;
    end
end

% Calculate average TP and FP across all frames for each threshold
avg_TP_SDIp_KN = mean(TPR_all_SDIp_KN);
avg_FP_SDIp_KN = mean(FPR_all_SDIp_KN);

% Display average TP and FP rates foor each threshold
for t = 1:length(thresholdDir)
    disp(['SDIp Threshold ' num2str(t) ':']);
    disp(['Average TP Rate (SDIp): ' num2str(avg_TP_SDIp_KN(t))]);
    disp(['Average FP Rate (SDIp): ' num2str(avg_FP_SDIp_KN(t))]);
    disp(' ');
end

%---------------------------

% Plot ROC curve with semi-log x-axis and labels
figure(1);
semilogx(avg_FP_SDIp_CR, avg_TP_SDIp_CR, 'r-x', 'LineWidth', 2, 'MarkerSize', 5);
hold on;
semilogx(avg_FP_SDIp_LD, avg_TP_SDIp_LD, 'b-x', 'LineWidth', 2, 'MarkerSize', 5);
semilogx(avg_FP_SDIp_KN, avg_TP_SDIp_KN, 'm-x', 'LineWidth', 2, 'MarkerSize', 5);
xlabel('False Positive Rate (FPR)');
ylabel('True Positive Rate (TPR)');
legend('SDIp – Carrier', 'SDIp – Cinecitta', 'SDIp – Knight', 'Location', 'northwest');
grid on;


% Add labels to data points
for i = 1:length(avg_FP_SDIp_CR)
    text(avg_FP_SDIp_CR(i), avg_TP_SDIp_CR(i), ['T' num2str(i)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

for i = 1:length(avg_FP_SDIp_LD)
    text(avg_FP_SDIp_LD(i), avg_TP_SDIp_LD(i), ['T' num2str(i)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

for i = 1:length(avg_FP_SDIp_KN)
    text(avg_FP_SDIp_KN(i), avg_TP_SDIp_KN(i), ['T' num2str(i)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

hold off;

% Save plot as EPS file
print -depsc ROC_All_SDIp.eps

