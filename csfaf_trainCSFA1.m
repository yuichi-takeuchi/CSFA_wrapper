function [chkptFile] = csfaf_trainCSFA1(loadFile,saveFile,modelOpts,trainOpts,kernelLrnng,scoreLrnng,chkptFile)
% trainCSFA
%   Trains a cross-spectral factor analysis (CSFA) model of the given LFP data. 
%   Generally, the data are given as averaged signal over each recording area,
%   divided into time windows. Learns a set of factors that describe the dataset
%   well, and models each window as a linear sum of contributions from each
%   factor. The model can be combined with supervised classifier in order to
%   force a set of the factors to be predictive of desired sid information. Run
%   the saveTrainRuns function after this to consolidate training results into
%   one file. For more details on the model refer to the following publication:
%   N. Gallagher, K.R. Ulrich, K. Dzirasa, L. Carin, and D.E. Carlson,
%     "Cross-Spectral Factor Analysis", Advances in Neural Information
%     Processing Systems 30, pp. 6845-6855, 2017.
%   INPUTS
%   loadFile: path to '.mat' file containing preprocessed data. Must contain
%        variables named xFft and labels variables, described below.
%   saveFile: path to '.mat' file to which the CSFA model will
%       ultimately be saved. If you wish to control the division of
%       data into train/validation/test sets, this file should be
%       already initialized with a sets variable, described below.
%       All models saved to this file should have the same validation sets.
%   modelOpts: (optional) Indicates  parameters of the CSFA model. All
%       non-optional fields not included in the structure passed in will be
%       filled with a default value.
%       FIELDS
%       discrimModel: string indicating the supervised classifier, if any,
%           that is combined with the CSFA model. options are
%           'none','svm','logistic', or 'multinomial'. Default: 'none'
%       L: number of factors. Default: 10 (L = {10,20,30})
%       Q: number of spectral gaussian components per factor. Default: 3 (Q = {3,5,8})
%       R: rank of coregionalization matrix. Default: 2 (R = {1,2})
%       eta: precision of additive gaussian noise. Default: 5 (eta = {5,20})
%       lowFreq: lower bound on spectral frequencies incorporated in the model.
%           Default: 1
%       highFreq: upper bound on spectral frequencies incorporated in the model.
%           Default: 50
%       description: (optional) string description of model
%       kernel: (optional) CSFA model object to initialize new model for
%           training
%       (The following are used if discrimModel is set to anything
%       other than 'none')
%       lambda: scalar ratio of the 'weight' on the classifier loss
%           objective compared to the CSFA model likelihood objective,
%            lambda = {1, 0.1, 0.01}, the lambda is larger, the limit is
%            stronger, which is for prevent overfitting
%       target: string indicating the field of labels.windows to be used as
%           the target variable to be explained by the classifier
%       dIdx: boolean vector of indicies for discriminitive
%           factors, e.g. modelOpts.dIdx = boolean([1,1,1,0,0,0,0,0,0,0]);
%           modelOpts.dIdx = boolean([1,1,1,1,1,1,1,1,1,1]);
%           It should be sufficient to just choose the first three factors in dIdx. 
%           Alternatively, what we have used for dIdx is to train a CSFA model first, 
%           and to choose the factors that perform best individually to distinguish 
%           whatever classes you are interested in. We have generally just used 3 factors,
%           although a more rigorous way to do this would be to validate the number of factors 
%           you choose along with the values of lambda.
%       mixed: (optional) boolean indicating whether to have mixed intercept
%           model for multiple groups
%       group: Only needed if mixed is set to 'true'. String indicating the
%           field of labels.windows to be used as the group variable for a
%           mixed intercept model
%   trainOpts: (optional) structure of options for the learning algorithm. All
%       non-optional fields not included in the structure passed in will be
%       filled with a default value. See the fillDefaultTopts function for
%       default values.
%       FIELDS
%       iters: maximum number of training iterations
%       evalInterval(2): interval at which to evaluate objective. evalInterval2
%           controls the interval for score learning
%           following initial kernel learning.
%       saveInterval: interval at which to save intermediate models during
%           training. 
%       convThresh(2), convClock(2): convergence criterion parameters. training
%           stops if the objective function does not 
%           increase by a value of at least (convThresh) after (convClock)
%           evaluations of the objective function. convThresh2 and
%           convClock2 correspond to score learning following kernel
%           learning.
%       algorithm: function handle to the desired gradient descent
%           algorithm for model learning. Stored in +algorithms/ 
%           Example: [evals,trainModels] = trainOpts.algorithm(labels.s,...
%                          xFft(:,:,sets.train),model,trainOpts,chkptFile);
%       stochastic: boolean indicating to train using mini-batches
%       batchSize: (only used if stochastic = true) mini-batch size
%           for stochastic algorithms 
%       projAll: boolean. If false, only learns scores from the final model
%           (obtained after all training iterations), rather than for each
%           intermediate model as well.
%   chkptFile: (optional) path of a file containing checkpoint information
%       for training to start from. For use if training had to be terminated
%       before completion.
%   LOADED VARIABLES
%   (from loadFile)
%   xFft: fourier transform of preprocessed data. NxAxW array. A is
%       the # of areas. N=number of frequency points per
%       window. W=number of time windows.
%   labels: Structure containing labeling infomation for data
%       FIELDS
%       s: frequency space (Hz) labels of fourier transformed data
%   (optionally loaded from saveFile)
%   sets: structure containing
%       train/validation set labels.
%       FIELDS
%       train: logical vector indicating windows in xFft to be used
%           in training set
%       val: (optional) logical vector indicating window to be used in
%           validation
%       datafile: path to file containing data used to train model
%       test: (optional) logical vector indicating windows for
%           testing
%       description: (optional) describes validation set scheme
%
% Example1: TrainCSFA('data/dataStore.mat','data/modelFile.mat',mOpts,tOpts)
% Example2: TrainCSFA('data/dataStore.mat','data/Mhold.mat',[],[],'data/chkpt_81LNf_Mhold.mat')

% Add .mat extension if filenames don't already include them
saveFile = addExt(saveFile);
loadFile = addExt(loadFile);

% initialize options structures if not given as inputs
if nargin < 4
    trainOpts = [];
end
if nargin < 3
    modelOpts = [];
end

% load data and associated info
load(loadFile,'xFft','labels')
nWin = size(xFft,3);

sets = loadSets(saveFile,loadFile,nWin);

if nargin < 7
    % initialize matfile for checkpointing
    chkptFile = generateCpFilename(saveFile)
    %     chkptFile = saveFile;% modified by Qun
    save(chkptFile,'modelOpts','trainOpts','sets')
else
    % load info from checkpoint file
    chkptFile = addExt(chkptFile);
    cp = load(chkptFile,'-mat');
    modelOpts = cp.modelOpts;
    trainOpts = cp.trainOpts;
    if isfield(cp,'trainIter'), trainIter = cp.trainIter; end
    if isfield(cp,'trainModels'), trainModels = cp.trainModels; end
    if isfield(cp,'projModels'), projModels = cp.projModels; end
    if isfield(cp,'evals'), evals = cp.evals; end
end

% fill in default options and remaining parameters
modelOpts.C = size(xFft,2); % number of signals
modelOpts.W = sum(sets.train);    % # of windows
modelOpts = fillDefaultMopts(modelOpts);
trainOpts = fillDefaultTopts(trainOpts);

%% Kernel learning
% % train kernels if they haven't been loaded from chkpt file
% if ~exist('projModels','var') && (~exist('trainIter','var') || trainIter~=Inf)
if kernelLrnng    
    if exist('trainModels','var') % implies chkptFile was loaded
        model = trainModels(end);
    else
        model = initModel(modelOpts,labels,sets)
    end
    
    % update model via gradient descent
    [evals, trainModels] = trainOpts.algorithm(labels.s,xFft(:,:,sets.train),model,...
                                            trainOpts,chkptFile);  
    fprintf('Kernel learning Complete\n')
end

%% Score learning
if scoreLrnng
    % Fix kernels and learn scores to convergence
    % initialize variables for projection
    nModels = numel(trainModels);
%     if exist('projModels','var')
%         % happens if there are checkpointed projection models
%         k = nModels - sum(~isempty(projModels));
%         initScores = projModels(k+1).scores;
%     else
        k = nModels;
        % initialize projected scores with training set scores
        initScores = nan(modelOpts.L,nWin);
        if size(initScores,2) == trainModels(k).scores
            initScores(:,sets.train) = trainModels(k).scores;
        end
%     end

    while k >= lastTrainIdx(nModels,trainOpts.projectAll)
        if isa(trainModels(k),'GP.CSFA')
            thisTrainModel = trainModels(k);
        else
            thisTrainModel = trainModels(k).kernel;
        end

        a = tic;
        modelRefit = projectCSFA(xFft,thisTrainModel,labels.s,trainOpts,...
            initScores);
        fprintf('Projected model %d: %.1fs\n',k,toc(a))
        projModels(k) = modelRefit.copy;

        save(chkptFile,'projModels','trainModels','evals',...
          'modelOpts','trainOpts','sets')

        % initialize next model with scores from current model
        initScores = modelRefit.scores;
        k = k-1;
    end
    fprintf('Score learning Complete\n')
end
if not(nargin < 7)
    chkptFile = generateCpFilename(saveFile)
end
save(chkptFile,'projModels','trainModels','evals',...
      'modelOpts','trainOpts','sets')
save(saveFile,'projModels','trainModels','evals',...
      'modelOpts','trainOpts','sets')
end

function sets = loadSets(saveFile,loadFile,nWin)
% load validation set options

% if exist(saveFile,'file')
%   load(saveFile,'sets')
% % allow user to set sets.train to true for training set
% % to include all data
%   if sets.train == true
%     sets.train = true(1,nWin);
%   end
% else
  sets.train = false(1,nWin);
  sets.train(randperm(nWin,floor(0.8*nWin))) = 1;
  sets.test = ~sets.train;
  sets.description = '80/20 split';
  sets.datafile = loadFile;
% end
end

function model = initModel(modelOpts,labels,sets)
% initialize CSFA or dCSFA model

if isa(modelOpts.discrimModel,'function_handle')
  target = modelOpts.target;
  model = GP.dCSFA(modelOpts,labels.windows.(target)(sets.train));
else
  switch modelOpts.discrimModel
    case 'none'
      model = GP.CSFA(modelOpts);
    case {'svm','logistic','multinomial'}
      target = modelOpts.target;
      if isfield(modelOpts,'mixed') && modelOpts.mixed
        group = modelOpts.group;
        model = GP.dCSFA(modelOpts,labels.windows.(target)(sets.train),...
                         labels.windows.(group)(sets.train));
      else
        model = GP.dCSFA(modelOpts,labels.windows.(target)(sets.train));
      end
    otherwise
      warning(['Disciminitive model indicated by modelOpts.discrimModel is '...
               'not valid. Model will be trained using GP generative model only.'])
      model = GP.CSFA(modelOpts);
  end
end
end

function chkptFile = generateCpFilename(saveFile)
% generate checkpoint file name that wont overlap with other checkpoint
% files for same dataset

  % generate random string
  symbols = ['a':'z' 'A':'Z' '0':'9'];
  ST_LENGTH = 5;
  nums = randi(numel(symbols),[1 ST_LENGTH]);
  st = ['chkpt_' symbols(nums),'_'];

  % add chkpt_ to start of filename (taking path into account)
  idx = regexp(saveFile,'[//\\]');
  if isempty(idx), idx = 0; end
  chkptFile = [saveFile(1:idx(end)),st,saveFile(idx(end)+1:end)];
end

function modelOpts = fillDefaultMopts(modelOpts)
% fill in default model options
if ~isfield(modelOpts,'L'), modelOpts.L = 10; end
if ~isfield(modelOpts,'Q'), modelOpts.Q = 3; end
if ~isfield(modelOpts,'R'), modelOpts.R = 2; end
if ~isfield(modelOpts,'eta'), modelOpts.eta = 5; end
if ~isfield(modelOpts,'lowFreq'), modelOpts.lowFreq = 1; end
if ~isfield(modelOpts,'highFreq'), modelOpts.highFreq = 50; end
if ~isfield(modelOpts,'maxW')
  modelOpts.maxW = min(modelOpts.W,1e4);
end
if ~isfield(modelOpts,'discrimModel')
  modelOpts.discrimModel = 'none';
end
end

function filename = addExt(filename)
% add .mat extension if not there
  if ~any(regexp(filename,'.mat$'))
    filename = [filename '.mat'];
  end
end

function idx = lastTrainIdx(nModels,projectAll)
  if projectAll
    idx = 1;
  else 
    idx = nModels;
  end
end
