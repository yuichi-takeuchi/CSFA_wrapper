%
% Copyright (c) Qun Li 2018, Yuichi Takeuchi 2019
clear; clc; close all
%% Building model info
lambda = 1;
ModelInfo = struct(...
    'modelfilebase', ['model_logistic_lambda' num2str(lambda)],... 
    'datafile', 'cutdata.mat',...
    'supervised', 1,...
    'discrimModel', 'logistic',...
    'lambda', lambda,...
    'MATLABFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'dataFolder', ['D:\Research\Analysis\Electome\LTRec1_106\Train7']...
    );

%% Move to MATLAB folder
cd(ModelInfo.MATLABFolder)

%% Move to data folder
cd(ModelInfo.dataFolder)

%% Plot an electome factor
% plot Example
factor_Idx = 10;% 1-10 factor

% load trained model
load(['data\' ModelInfo.modelfilebase '.mat'], 'trainModels', 'modelOpts')
model = trainModels(end); 

% load frquency bounds
minFreq = modelOpts.lowFreq;
maxFreq = modelOpts.highFreq;

% load frquency bounds
dataFile = ['data\' ModelInfo.datafile];
load(dataFile,'labels')
channelLabel = labels.channellabel;

% plot set of spectral densities for factor
electomef_plotRelativeCsd_dCSFA1(model,factor_Idx,'minFreq',minFreq,'maxFreq',maxFreq,'names',channelLabel)

clear maxFreq minFreq trainModels modelOpts dataFile channelLabel

    % figure parameter settings
set(gcf,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 49 34],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [50 35]... % width, height
    );
    
%     % axis parameter settings
%     set(gca,...
%         'FontName', fontname,...
%         'FontSize', fontsize...
%         );

print([ModelInfo.modelfilebase '_Factor' num2str(factor_Idx) '.pdf'],'-dpdf')
print([ModelInfo.modelfilebase '_Factor' num2str(factor_Idx) '.jpg'],'-djpeg')
clear factor_Idx

%% close all
