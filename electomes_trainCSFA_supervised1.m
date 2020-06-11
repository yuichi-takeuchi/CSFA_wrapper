%
% Copyright (c) Yuichi Takeuchi 2019
clear; clc; close all
%% Load RecInfo
% load('RecInfo.mat')
load('RecInfoCombined.mat')
RecInfo = RecInfo1; clear RecInfo1

%% Move to MATLAB folder
cd(RecInfo.MATLABFolder)

%% Move to data folder
cd(RecInfo.dataFolder)

%% Move to Analysis folder
cd(RecInfo.trainFolder) % or cd(RecInfo2.trainFolder)

%% ============== logistic lambda = x ==============
% parameter preparation
newModel = 0;
lambda = 1; % 1, 0.1, 0.01
discrimModel = 'logistic';%string indicating the supervised classifier, if any,
%           that is combined with the CSFA model. options are
%           'none','svm','logistic', or 'multinomial'. Default: 'none'

% dataFile
% dataFolder = [RecInfo.dataFolder '\data'];
dataFolder = [RecInfo.trainFolder '\data'];
% dataFile = [dataFolder '\' RecInfo.lfpmatfilenamebase '_1_cutdata.mat'];
dataFile = [dataFolder '\cutdata.mat'];

% saveFile
load([dataFolder '\cvSplit1.mat'])
sets.datafile = dataFile;
saveFileName = ['model_logistic_lambda' num2str(lambda) '.mat'];
if(newModel)
    save([dataFolder '\' saveFileName], 'sets')
    disp('new model')
else
    copyfile([RecInfo.pretrainFolder '\data\' saveFileName], [RecInfo.trainFolder '\data\' saveFileName])
    save([dataFolder '\' saveFileName], 'sets', '-append')
    disp('inherited')
end
saveFile = [dataFolder '\' saveFileName];
clear saveFileName

% modelOpts
modelOpts.discrimModel = discrimModel;
% modelOpts.description = 'default';
% modelOpts.eta = 5;
modelOpts.lambda = lambda;
modelOpts.target = 'label1'; % arbitrary label
modelOpts.dIdx = logical([1,1,1,0,0,0,0,0,0,0]);
modelOpts.lowFreq = 1;
modelOpts.highFreq = 50;

% trainOpt
trainOpts.iters = 50; % 100
trainOpts.saveInterval = 25; % 50

clear lambda setNo discrimModel newModel dataFolder

%% Train dCSFA
rng('shuffle')
electomef_trainCSFA1(dataFile,saveFile,modelOpts,trainOpts);
disp('train1 done')

%% Train alone
chkptFile = saveFile;
h = waitbar(0,'CSF training...');
for i = 2:5
    waitbar(i/5);     rng('shuffle')
    electomef_trainCSFA2(dataFile,saveFile,modelOpts,trainOpts,chkptFile);
    disp(['train' num2str(i) ' done'])
end
close(h)
disp('further training done')
clear i h 

%% Copy template .m file
copyfile([RecInfo.MATLABFolder '\Yuichi\CSFA\electomes_trainCSFA_supervised1.m'],...
    [RecInfo.dataFolder '\electomes_electomes_trainCSFA_supervised1.m']);

%% Save to struct
load(saveFile)
electomef_saveToStruct1(trainModels, saveFile, 0) % flag = 0, save train
electomef_saveToStruct1(projModels, saveFile, 1) % flag = 1, save proj
disp('done')
