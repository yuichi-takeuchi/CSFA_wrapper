% 
% Copyright (C) Li Qun 2018, Yuichi Takeuchi 2019
%
% AIM: preprocess_cutdata is for extract channels for use, 
% change dataset into a usable format(cut to small windows), give the labels
%
%   OUTPUTS
%   data and labels
%
%   SAVED VARIABLES
%   (saved to saveFile)
%   data: NxRxW array of the data for each delay length. N is the #
%       of time points. R is the # of channels. W is the # of
%       windows. All elements corresponding to data that was not
%       save (i.e. missing channel) should be marked with NaNs.
%   labels: Structure containing labeling infomation for data
%       FIELDS
%       channel: cell arrays of labels for channels
%       fs: sampling frequency of data (Hz)
%       windowLength: length of a single time window (s)
%       windows: struct array for each individual window
%           FIELDS
%           videoID: video id number
%           subjectID: participant id number
%           valence, arousal, dominance, liking: deap emotion labels
%
% Initialization
clear; clc; close all

%% Load RecInfo
load('RecInfo.mat')

%% Move to MATLAB folder
cd(RecInfo.MATLABFolder)

%% Move to data folder
cd(RecInfo.dataFolder)

%% Parameter initialization
RecInfo.rat = 1; % 1 or 2
label1 = 0; % e.g. kindled state
CHANNEL = [1, 4, 7, 10, 14, 16, 20, 23, 25, 28];% 2 in MEC, 3 in rHPC, 3 in lHPC, 1 in S1, 1 in M1
CHANNEL_LABEL = {'MEC1','MEC2','raHPC','rmHPC', 'rpHPC','laHPC','lmHPC', 'lpHPC', 'S1', 'M1'};
FS = 200;
WINDOW_LENGTH = 5; % seconds

%% load data: data points*channels
load([RecInfo.lfpmatfilenamebase '_' num2str(RecInfo.rat) '_LFP.mat'])

N = WINDOW_LENGTH*FS;
R = numel(CHANNEL);
W = floor(size(data,2)/N);

data = data(CHANNEL,:); % channel extraction
data = data(1:N*R*W); % 
data = reshape(data,[R,N,W]); % cut window, each one is 5s
data = permute(data, [2 1 3]); % recording point * channel * window
clear N R

%% Initialize labels
labels.fs = FS;
labels.channel = CHANNEL;
labels.channellabel = CHANNEL_LABEL;
labels.windowLength = WINDOW_LENGTH;

% labels.windows.valence = zeros(W,1);
% labels.windows.arousal = zeros(W,1);
% labels.windows.dominance = zeros(W,1);
% labels.windows.liking = zeros(W,1);
% labels.windows.videoID = zeros(W,1,'uint16');
labels.windows.subjectID = zeros(W,1,'uint16');

% User defined label
labels.windows.label1 = zeros(W,1);

%%  Update labels
label1 = label1; % e.g. kindled state

% labels.windows.valence = true(W,1);
% labels.windows.arousal = false(W,1);
% labels.windows.dominance = false(W,1);
% labels.windows.liking = false(W,1);
% labels.windows.videoID = 424*ones(W,1); %ID VALUE
sizeOfTestWindows = floor(W/20);

% subjectID
for i = 1:20
    labels.windows.subjectID((i-1)*sizeOfTestWindows+1:i*sizeOfTestWindows) = i*ones(sizeOfTestWindows,1); % ID VALUE
end
labels.windows.subjectID(~labels.windows.subjectID) = 1; clear i

% label1
if(label1)
    labels.windows.label1 = true(W,1);
else
    labels.windows.label1 = false(W,1);
end

clear FS CHANNEL WINDOW_LENGTH W CHANNEL CHANNEL_LABEL label1 sizeOfTestWindows

%% Save cutdata.mat file
mkdir([RecInfo.dataFolder '\data'])
save([RecInfo.dataFolder '\data\' RecInfo.lfpmatfilenamebase '_' num2str(RecInfo.rat) '_cutdata.mat'],...
    'data','labels','-v7.3')

%% Save RecInfo.mat file
save(['RecInfo' num2str(RecInfo.rat) '.mat'], 'RecInfo', '-v7.3')

%% Copy template .m file
copyfile([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_cutData1.m'],...
    [RecInfo.dataFolder '\electomes_cutData1.m']);

%% Next script for 
edit([RecInfo.MATLABFolder '\Yuichi\Electome\electomes_xFft1.m'])
