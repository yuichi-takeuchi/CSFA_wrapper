%
% Copyright (c) Yuichi Takeuchi 2019
clear; clc; close all
%% Organize summary info
SummaryInfo = struct(...
    'MATLABFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis\Lambda1'...
    );
%     'analysisFolder', 'D:\Research\Scrivener\SeizureNetwork\Figures\Figure1\Analysis'...

%% Move to MATLAB folder
cd(SummaryInfo.MATLABFolder)

%% Move to analysis folder
cd(SummaryInfo.analysisFolder)

%% Load summary mat file
load([SummaryInfo.analysisFolder '\ScoreSummary.mat'], 'ScoreSummary')

%% Get scores to plot
LTR = [ScoreSummary.LTR];
lambda = [ScoreSummary.lambda];
day = [ScoreSummary.day];

LTRToPlot = [106];
dayToPlot = [-3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];

% lamda 1
for j = 1:length(dayToPlot)
    for k = 1:length(LTRToPlot)
        recNo = find(lambda == 1 & day == dayToPlot(j) & LTR == LTRToPlot(k));
        tempMeanScore(:,k) = mean(ScoreSummary(recNo).scores,2); % (Electome factors mean scores of each day)
    end
    srcMatY(:,j) = mean(tempMeanScore, 2); % (Electome factors, mean scores of animals) 
%     srcMatEB(:,j) = std(tempMeanScore, 2); % (Electome factors, standard deviation scores of animals
end
clear LTR lambda LTRToPlot j k recNo tempMeanScore day

%% Plot scores of electome factor
CTitle = 'Electome Facotor scores';
CHLabel = 'kindliing day';
CVLabel = 'Mean CSF score';
CLeg = {'Factor 1'; 'Factor 2'; 'Factor 3'; 'Factor 4'; 'Factor 5'; 'Factor 6'; 'Factor 7'; 'Factor 8'; 'Factor 9'; 'Factor 10'};
outputGraph = [1 1];
outputFileNameBase = 'ElectomeFactorTimecourse';
[ flag ] = figsf_PlotWLegend3( dayToPlot, srcMatY(1:10,:), CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);
% [ flag ] = figsf_PlotEBWLegend2( dayToPlot, srcMatY, srcMatEB, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);
% [ flag ] = figsf_PlotWLegend2( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase);
clear CHLabel CLeg CTitle CVLabel outputGraph outputFileNameBase flag

%% Copy template .m file
copyfile([SummaryInfo.MATLABFolder '\Yuichi\Electome\electomes_plotScoreTimeseries1.m'],...
    [SummaryInfo.analysisFolder '\electomes_plotScoreTimeseries1.m']);
