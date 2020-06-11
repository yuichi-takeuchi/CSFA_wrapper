%
% Copyright (c) 2019 Yuichi Takeuchi
clear; clc; close all
%% Loading RecInfo.
load('RecInfo.mat')

%% Move to MATLAB folder
cd(RecInfo.MATLABFolder)

%% Move to data folder
cd(RecInfo.dataFolder)

%% extract LFPdata for electome
k = RecInfo.expnum1(1);
l = RecInfo.expnum2(1);

RecInfo.lfpmatfilenamebase = [RecInfo.datfilenamebase num2str(k,'%02.f') '_' num2str(l,'%02.f')];

m = memmapfile([RecInfo.lfpmatfilenamebase '_1_LFP_reorg.dat'], 'format','int16');
d = m.data;
data = reshape(d, (RecInfo.nChannels-3)/2, []);
save([RecInfo.lfpmatfilenamebase  '_1_LFP.mat'],'data','-v7.3')

m = memmapfile([RecInfo.lfpmatfilenamebase '_2_LFP_reorg.dat'], 'format','int16');
d = m.data;
data = reshape(d, (RecInfo.nChannels-3)/2, []);

save([RecInfo.datfilenamebase num2str(k,'%02.f') '_' num2str(l,'%02.f') '_2_LFP.mat'],'data','-v7.3')
clear m d data k l
disp('done')

%% Save RecInfo
save('RecInfo.mat', 'RecInfo', '-v7.3')
disp('done')

%% Copy template .m file
copyfile([RecInfo.MATLABFolder '\Yuichi\CSFA\electomes_extractLFP1.m'],...
    [RecInfo.dataFolder '\electomes_extractLFP1.m']);

%% Next scirpt for electome analysis
edit([RecInfo.MATLABFolder '\Yuichi\CSFA\electomes_cutData1.m'])
