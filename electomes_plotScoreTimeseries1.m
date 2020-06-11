%
% Copyright (c) Yuichi Takeuchi 2019
clear; clc; close all
%% Organize summary info
SummaryInfo = struct(...
    'MATLABFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis\LambdaTest'...
    );
% 'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis'...

%% Move to MATLAB folder
cd(SummaryInfo.MATLABFolder)

%% Move to analysis folder
cd(SummaryInfo.analysisFolder)

%% Load summary mat file
load([SummaryInfo.analysisFolder '\ScoreSummary.mat'], 'ScoreSummary')

%% Get scores to plot
lambda = [ScoreSummary.lambda];
day = [ScoreSummary.day];

% lamda 1
ind = lambda == 1 & day == -3;
prelambda1 = ScoreSummary(ind).scores;
ind = lambda == 1 & day == 10;
postlambda1 = ScoreSummary(ind).scores;

% lamda 0.1
ind = lambda == 0.1 & day == -3;
prelambda01 = ScoreSummary(ind).scores;
ind = lambda == 0.1 & day == 10;
postlambda01 = ScoreSummary(ind).scores;

% lamda 0.01
ind = lambda == 0.01 & day == -3;
prelambda001 = ScoreSummary(ind).scores;
ind = lambda == 0.01 & day == 10;
postlambda001 = ScoreSummary(ind).scores;

clear day lambda ind

%% Plot 60 s scores of electome factor 1
srcX = 0:5:3600;
srcMatY = zeros(6,721);
srcMatY(1,:) = prelambda1(1,1:721);
srcMatY(2,:) = prelambda01(1,1:721);
srcMatY(3,:) = prelambda001(1,1:721);
srcMatY(4,:) = postlambda1(1,1:721);
srcMatY(5,:) = postlambda01(1,1:721);
srcMatY(6,:) = postlambda001(1,1:721);

CTitle = 'Electome Facotor 1 scores';
CHLabel = 'Time (s)';
CVLabel = 'CSF score';
CLeg = {'pre lambda 1'; 'pre lambda 0.1'; 'pre lambda 0.01'; ' post lambda 1'; 'post lambda 0.1'; 'post lambda 0.01'};
outputGraph = [1 1];
outputFileNameBase = 'electome_matched1';

[ flag ] = figsf_PlotWLegend2( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);

%% Plot 60 s scores of electome factor 1
srcX = 0:5:3600;
srcMatY = zeros(6,721);
srcMatY(1,:) = prelambda1(1,1:721);
srcMatY(2,:) = prelambda01(1,1:721);
srcMatY(3,:) = prelambda001(1,1:721);
srcMatY(4,:) = postlambda1(1,1:721);
srcMatY(5,:) = postlambda01(1,1:721);
srcMatY(6,:) = postlambda001(1,1:721);

CTitle = 'Electome Facotor 1 scores';
CHLabel = 'Time (s)';
CVLabel = 'CSF score';
CLeg = {'pre lambda 1'; 'pre lambda 0.1'; 'pre lambda 0.01'; ' post lambda 1'; 'post lambda 0.1'; 'post lambda 0.01'};
outputGraph = [1 1];
outputFileNameBase = 'electome_matched1';
[ flag ] = figsf_PlotWLegend2( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);
clear flag srcX srcMatY CTitle CHLabel CVLabel CLeg outputGraph outputFileNameBase

%% Plot 60 s scores of electome factor 2
srcX = 0:5:3600;
srcMatY = zeros(6,721);
srcMatY(1,:) = prelambda1(2,1:721);
srcMatY(2,:) = prelambda01(2,1:721);
srcMatY(3,:) = prelambda001(2,1:721);
srcMatY(4,:) = postlambda1(2,1:721);
srcMatY(5,:) = postlambda01(2,1:721);
srcMatY(6,:) = postlambda001(2,1:721);

CTitle = 'Electome Facotor 2 scores';
CHLabel = 'Time (s)';
CVLabel = 'CSF score';
CLeg = {'pre lambda 1'; 'pre lambda 0.1'; 'pre lambda 0.01'; ' post lambda 1'; 'post lambda 0.1'; 'post lambda 0.01'};
outputGraph = [1 1];
outputFileNameBase = 'electome_matched2';
[ flag ] = figsf_PlotWLegend2( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);
clear flag srcX srcMatY CTitle CHLabel CVLabel CLeg outputGraph outputFileNameBase

%% Plot 60 s scores of electome factor 3
srcX = 0:5:3600;
srcMatY = zeros(6,721);
srcMatY(1,:) = prelambda1(3,1:721);
srcMatY(2,:) = prelambda01(3,1:721);
srcMatY(3,:) = prelambda001(3,1:721);
srcMatY(4,:) = postlambda1(3,1:721);
srcMatY(5,:) = postlambda01(3,1:721);
srcMatY(6,:) = postlambda001(3,1:721);

CTitle = 'Electome Facotor 3 scores';
CHLabel = 'Time (s)';
CVLabel = 'CSF score';
CLeg = {'pre lambda 1'; 'pre lambda 0.1'; 'pre lambda 0.01'; ' post lambda 1'; 'post lambda 0.1'; 'post lambda 0.01'};
outputGraph = [1 1];
outputFileNameBase = 'electome_matched3';
[ flag ] = figsf_PlotWLegend2( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);
clear flag srcX srcMatY CTitle CHLabel CVLabel CLeg outputGraph outputFileNameBase

%% Copy template .m file
copyfile([SummaryInfo.MATLABFolder '\Yuichi\Electome\electomes_plotScoreTimeseries1.m'],...
    [SummaryInfo.analysisFolder '\electomes_plotScoreTimeseries1.m']);
