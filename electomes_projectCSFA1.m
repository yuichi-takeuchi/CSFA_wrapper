%
% Copyright (c) 2019 Yuichi Takeuchi
clear; clc; close all
%% Load RecInfo
load('RecInfo1.mat')
% load('RecInfo2.mat')

%% Move to MATLAB folder
cd(RecInfo.MATLABFolder)

%% Move to data folder
cd(RecInfo.dataFolder)

%% project 
% parameter preparation
lambda = 1;

% dataFile
dataFolder = [RecInfo.dataFolder '\data'];
dataFile = [dataFolder '\' RecInfo.lfpmatfilenamebase '_' num2str(RecInfo.rat) '_cutdata.mat'];

% saveFile
load([dataFolder '\cvSplit1_' num2str(RecInfo.rat) '.mat'])
saveFileName = ['model_logistic_lambda' num2str(lambda) '.mat'];
save([dataFolder '\' saveFileName], 'sets', '-append')
saveFile = [dataFolder '\' saveFileName];
clear saveFileName

modelOpts = [];
trainOpts = [];
chkptFile = saveFile;
clear lambda dataFolder

%% Project dCSFA
electomef_projectCSFA1(dataFile,saveFile,modelOpts,trainOpts,chkptFile);
disp('done')

%% Save to struct
load(saveFile)
electomes_saveToStruct1(trainModels, saveFile, 0) %flag=0, save train_
electomes_saveToStruct1(projModels, saveFile, 1)

%% Copy template .m file
copyfile([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_projectCSFA1.m'],...
    [RecInfo.dataFolder '\electomes_projectCSFA1.m']);

