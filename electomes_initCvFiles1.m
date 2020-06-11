% Copyright (c) 2019 Yuichi Takeuchi
clear; clc; close all
%% Load RecInfo depending on rat number
load('RecInfo1.mat')
% load('RecInfo2.mat')

%% Move to MATLAB folder
cd(RecInfo.MATLABFolder)

%% Move to data folder
cd(RecInfo.dataFolder)

%% Make a new data Folder
% mkdir('data')
RecInfo.dataFolder1 = [RecInfo.dataFolder '\data'];

% %% Move data to a new data folder
% movefile([RecInfo.lfpmatfilenamebase '_1_cutdata.mat'],...
%     [RecInfo.DataFolder '\data\' RecInfo.lfpmatfilenamebase '_1_cutdata.mat'])

%% Prepare sets
electomef_initCvFiles1([RecInfo.lfpmatfilenamebase '_' num2str(RecInfo.rat) '_cutdata.mat'])
cd('data')
listing = dir('cvSplit*.mat');
for i = 1:length(listing)
    movefile(listing(i).name, ['cvSplit' num2str(i) '_' num2str(RecInfo.rat) '.mat'])
end
cd('..')
disp('done'); clear i listing

%% Copy template .m file
copyfile([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_initCvFiles1.m'],...
    [RecInfo.dataFolder '\electomes_initCvFiles1.m']);

%% Next script for Electome analysis
edit([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_concatenateData1.m'])
