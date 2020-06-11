%
% Copyright (c) Yuichi Takeuchi 2019
clear; clc; close all
date = 190521;
day = -2;
lambda = 1; % 1, 0.1, 0.01

%% Organize summary info
SummaryInfo = struct(...
    'MATLABFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis\Lambda1'...
    );
%     'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis'...
%     'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis\LambdaTest'...
    

%% Move to MATLAB folder
cd(SummaryInfo.MATLABFolder)

%% Move to Analysis Folder
cd(SummaryInfo.analysisFolder)

%% Load summary mat file
load([SummaryInfo.analysisFolder '\ScoreSummary.mat'], 'ScoreSummary')

%% Organize model file data
LTR = 106;
% date = 190529;
rat = 1;
supervised = 1;
discrim = 'logistic';
% lambda = 1; % 1, 0.1, 0.01
label = 1; % 1: matched, 0: shuffled
% day = 3;
ModelInfo = struct(...
    'LTR', 106,...
    'date', date,...
    'rat', rat,...
    'supervised', supervised,...
    'discrim', discrim,...
    'lambda', lambda,...
    'label', label,...
    'day', day,...
    'dataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_106_107\' num2str(date) '\data'],...
    'modelnameSrc', ['model_' discrim '_lambda' num2str(lambda) '.mat'],...
    'modelnameDest', ['model_rat' num2str(rat) '_' discrim '_lambda' num2str(lambda) '_label' num2str(label) '.mat']...
    );
clear LTR date rat supervised discrim lambda label day

% 'dataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_106_107\' num2str(date) '\data\LambdaTest'],...

%% Move to data folder
cd(ModelInfo.dataFolder)

%% Rename model file
movefile(ModelInfo.modelnameSrc, ModelInfo.modelnameDest)

%% Load model file
load(ModelInfo.modelnameDest, 'projModels')

%% Append the model file data to ScoreSummary
recNo = length(ScoreSummary) + 1;
ScoreSummary(recNo).LTR = ModelInfo.LTR;
ScoreSummary(recNo).date = ModelInfo.date;
ScoreSummary(recNo).rat = ModelInfo.rat;
ScoreSummary(recNo).supervised = ModelInfo.supervised;
ScoreSummary(recNo).discrim = ModelInfo.discrim;
ScoreSummary(recNo).lambda = ModelInfo.lambda;
ScoreSummary(recNo).label = ModelInfo.label;
ScoreSummary(recNo).day = ModelInfo.day;
ScoreSummary(recNo).scores = projModels(end).scores;
clear recNo projModels

%% Save summary mat file to the analysis folder
save([SummaryInfo.analysisFolder '\ScoreSummary.mat'], 'ScoreSummary')
clear ScoreSummary

%% Copy template .m file
copyfile([SummaryInfo.MATLABFolder '\Yuichi\Electome\electomes_collectElectomeScores1.m'],...
    [ModelInfo.dataFolder '\electomes_collectElectomeScores1.m']);

%% Initialize ScoreSummary
% ScoreSummary = struct();
% save([SummaryInfo.analysisFolder '\ScoreSummary.mat'], 'ScoreSummary')
