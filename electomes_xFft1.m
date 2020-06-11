% Copyright (c) 2019 Yuichi Takeuchi
clear; clc; close all
%% Load RecInfo depending on rat number
load('RecInfo1.mat')
% load('RecInfo2.mat')

%% Move to MATLAB folder
cd(RecInfo.MATLABFolder)

%% Move to data folder
cd(RecInfo.dataFolder)

%% Fast Fourier Transformation
electomef_xFft1([RecInfo.dataFolder '\data\' RecInfo.lfpmatfilenamebase '_' num2str(RecInfo.rat) '_cutdata.mat'])
disp('done')

% %% Change name of RecInfo
% copyfile('RecInfo.mat', [RecInfo.lfpmatfilenamebase '_RecInfo.mat'])

%% Copy template .m file
copyfile([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_xFft1.m'],...
    [RecInfo.dataFolder '\electomes_xFft1.m']);

%% Next script for Electome analysis
edit([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_initCvFiles1.m'])
