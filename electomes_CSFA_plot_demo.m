
%% =============== plot logistic_demo ===========================
clc
clear
%plotExample
MODELFILE = 'modelfile_logistic_demo.mat';
DATAFILE = 'cutdata.mat';
FACTOR_IDX = 1;% 1-10 factor

CHANNEL_LABEL = {'MEC1','MEC2','raHPC','rmHPC', 'rpHPC','laHPC','lmHPC', 'lpHPC', 'S1', 'M1'};
% load trained model
load(MODELFILE)
model = trainModels(end); 
% model = projModels(end);

% load frquency bounds
load(DATAFILE,'dataOpts')
minFreq = dataOpts.lowFreq;
maxFreq = dataOpts.highFreq;

% plot set of spectral densities for factor
plotRelativeCsd_dCSFA(model,FACTOR_IDX,'minFreq',minFreq,'maxFreq',maxFreq,'names',CHANNEL_LABEL)

%% =============== plot log_01 ===========================
% clc
% clear
% %plotExample
% MODELFILE = 'modelfile_log_01.mat';
% DATAFILE = 'cutdata.mat';
% FACTOR_IDX = 1;
% MODEL_IDX = 1;
% CHANNEL_LABEL = {'mPFC1','mPFC2','Amy1','Amy2','Hip1','Hip2','MEC'};
% % load trained model
% load(MODELFILE)
% model = trainModels(end);
% 
% 
% % load frquency bounds
% load(DATAFILE,'dataOpts')
% minFreq = dataOpts.lowFreq;
% maxFreq = dataOpts.highFreq;
% 
% % plot set of spectral densities for factor
% %model.plotRelativeCsd(FACTOR_IDX,'minFreq',minFreq,'maxFreq',maxFreq,'names',CHANNEL_LABEL)
% plotRelativeCsd_dCSFA(model,FACTOR_IDX,'minFreq',minFreq,'maxFreq',maxFreq,'names',CHANNEL_LABEL)

%% ============ project model ======================
clc
clear
%plotExample
MODELFILE = 'modelfile_logistic_demo.mat';
DATAFILE = 'cutdata.mat';
FACTOR_IDX = 4;
% MODEL_IDX = 1;
CHANNEL_LABEL = {'mPFC1','mPFC2','Amy1','Amy2','Hip1','Hip2','MEC'};
% load trained model
load(MODELFILE)
%model = trainModels(end);
model = projModels(end);

% load frquency bounds
load(DATAFILE,'dataOpts')
minFreq = dataOpts.lowFreq;
maxFreq = dataOpts.highFreq;
% plot set of spectral densities for factor
model.plotRelativeCsd(FACTOR_IDX,'minFreq',minFreq,'maxFreq',maxFreq,'names',CHANNEL_LABEL)