%
% Copyright (c) 2019 Yuichi Takeuchi
clear; clc; close all
%% Training folder
trainSession = 8;
trainFolder = ['D:\Research\Analysis\Electome\LTRec1_106\Train' num2str(trainSession)];
pretrainFolder = ['D:\Research\Analysis\Electome\LTRec1_106\Train' num2str(trainSession-1)];
clear trainSession

%% Organizing RecInfo1
date = 190526;
datfilenamebase = ['AP_' num2str(date) '_exp'];
expnum1 = 1;
expnum2 = 1;
RecInfo1 = struct(...
    'expnum1', expnum1,...
    'expnum2', expnum2,...
    'datfilenamebase', datfilenamebase,...
    'matfilenamebase', [datfilenamebase '_DatPrep_Template1'],...
    'lfpmatfilenamebase', [datfilenamebase num2str(expnum1,'%02.f') '_' num2str(expnum2,'%02.f')],...
    'nChannels', 63,...
    'rat', 1,...
    'sr', 20000,...
    'srLFP', 200,... % 1250 Hz
    'MATLABFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'dataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_106_107\' num2str(date)],...
    'trainFolder', trainFolder,...
    'pretrainFolder', pretrainFolder...
    );
clear datfilenamebase date expnum1 expnum2

%% Organizing RecInfo2
date = 190627;
datfilenamebase = ['AP_' num2str(date) '_exp'];
expnum1 = 2;
expnum2 = 1;
RecInfo2 = struct(...
    'expnum1', expnum1,...
    'expnum2', expnum2,...
    'datfilenamebase', datfilenamebase,...
    'matfilenamebase', [datfilenamebase '_DatPrep_Template1'],...
    'lfpmatfilenamebase', [datfilenamebase num2str(expnum1,'%02.f') '_' num2str(expnum2,'%02.f')],...
    'nChannels', 63,...
    'rat', 1,...
    'sr', 20000,...
    'srLFP', 200,... % 1250 Hz
    'MATLABFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'dataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_106_107\' num2str(date)],...
    'trainFolder', trainFolder,...
    'pretrainFolder', pretrainFolder...
    );
clear datfilenamebase date expnum1 expnum2

%% Move to MATLAB folder
cd(RecInfo1.MATLABFolder)

%% Move to data folder1
cd(RecInfo1.dataFolder)

%% Move to data folder2
cd(RecInfo2.dataFolder)

%% Move to Pre-Train folder
cd(RecInfo1.pretrainFolder) % or cd(RecInfo2.trainFolder)

%% Move to Train folder
cd(RecInfo1.trainFolder) % or cd(RecInfo2.trainFolder)

%% Copy data folders and concatenate
srcfldr1 = [RecInfo1.dataFolder '\data'];
srcfldr2 = [RecInfo2.dataFolder '\data'];
dstfldr1 = [RecInfo1.trainFolder '\data1'];
dstfldr2 = [RecInfo2.trainFolder '\data2'];
copyfile(srcfldr1, dstfldr1)
copyfile(srcfldr2, dstfldr2)

%% Concatenate cutdata
load([dstfldr1 '\' RecInfo1.lfpmatfilenamebase '_' num2str(RecInfo1.rat) '_cutdata.mat'], 'xFft', 'labels')
xFft1 = xFft; labels1 = labels; clear xFft labels
load([dstfldr2 '\' RecInfo2.lfpmatfilenamebase '_' num2str(RecInfo2.rat) '_cutdata.mat'], 'xFft', 'labels')
xFft2 = xFft; labels2 = labels; clear xFft labels
xFft = cat(3,xFft1, xFft2); clear xFft1 xFft2

labels.fs = labels1.fs;
labels.channel = labels1.channel;
labels.channellabel = labels1.channellabel;
labels.windowLength = labels1.windowLength;
labels.s = labels1.s;
labels.windows.subjectID = [labels1.windows.subjectID; labels2.windows.subjectID];
labels.windows.label1 = [labels1.windows.label1; labels2.windows.label1]; clear labels1 labels2

mkdir('data')
save('data\cutdata.mat', 'xFft', 'labels'); clear xFft labels

%% Concatenate sets data
load([dstfldr1 '\cvSplit1_1.mat'], 'sets')
sets1 = sets; clear sets
load([dstfldr2 '\cvSplit1_1.mat'], 'sets')
sets2 = sets; clear sets

sets.datafile = 'data\cutdata.mat';
sets.test = [sets1.test; sets2.test];
sets.train = [sets1.train; sets2.train];
clear sets1 sets2

save('data\cvSplit1.mat', 'sets'); clear sets

%% Save RecInfoCombined
save('RecInfoCombined', 'RecInfo1', 'RecInfo2')

%% Copy template .m file
copyfile([RecInfo1.MATLABFolder '\Yuichi\CSFA\electomes_concatenateData1.m'],...
    [RecInfo1.trainFolder '\electomes_concatenateData1.m']);

%% Next script for Electome analysis
edit([RecInfo1.MATLABFolder '\Yuichi\CSFA\electomes_trainCSFA_supervised1.m'])
