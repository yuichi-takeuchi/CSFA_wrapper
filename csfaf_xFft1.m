% modified from preprocessDeap by Qun (2018), Yuichi (2019)
function csfaf_xFft1(saveFile,dataOpts)
% preprocessDeap
%   Preprocesses data saved in saveFile. Typically run after prerocess_cutdata.
%
%   INPUTS
%   saveFile: name of '.mat' file containing the data and labels
%       variables. And to which the fully preprocessed data will be saved
%       CONTAINS
%       data: NxRxW array of the data for each delay length. N is the #
%         of time points. R is the # of channels. W is the # of
%         windows. All elements corresponding to data that was not
%         save (i.e. missing channel) should be marked with NaNs.
%       labels: Structure containing labeling infomation for data
%         FIELDS
%         channel: cell arrays of labels for channels
%         fs: sampling frequency of data (Hz)
%         windowLength: length of a single time window (s)
%         windows: struct array for each individual window
%           FIELDS
%           videoID: video id number
%           subjectID: participant id number
%           valence, arousal, dominance, liking: deap emotion labels
%   dataOpts: optional input. see description in saved variables section
%
%   LOADED VARIABLES
%   (from saveFile)
%   data: NxRxW array of the data for each delay length. N is the #
%       of time points. R is the # of channels. W is the # of
%       windows. All elements corresponding to data that was not
%       save (i.e. missing channel) should be marked with NaNs.
%   labels: Structure containing labeling infomation for data
%       FIELDS
%       channel: cell arrays of names for channels
%       fs: sampling frequency of unprocessed data (Hz)
%       windowLength: length of data windows in seconds
%       windows: structure containing relevant labels pertaining to
%           individual windows. Suggested fields: date, etc. Must
%           contain 'mouse' field.
%   SAVED VARIABLES
%   (saved to saveFile)
%   labels: see above
%       ADDED FIELDS
%       area: cell array of labels for each area corresponding to
%           the second dimension of xFft
%       fs: sampling frequency of processed data (Hz)
%       s: frequency space labels of fourier transformed data
%       windows: same as windows, but with unusable windows eliminated
%   dataOpts: Data preprocessing options.
%       FIELDS
%       highFreq/lowFreq: boundaries of frequencies considered by
%           the model
%       subSampFact: subsampling factor
%       normWindows: boolean indication whether to normalize
%           individual windows. If false, dataset is normalized as
%           a whole, and individual windows are still mean
%           subtracted.
%   xFft: fourier transform of preprocessed data. NxAxW array. A is
%       the # of areas. N=number of frequency points per
%       window. W=number of time windows.

%DATA_DIR = 'data/';
  
if nargin < 2
  % input/data preprocessing parameters
  dataOpts.highFreq = 45;
  dataOpts.lowFreq = 1;
  %dataOpts.normalizeBy = 'subject';
  dataOpts.normalizeBy = 'window';
end

load([saveFile])

%initialize some variables
fs = labels.fs;
nAreas = size(data,2);
ptsPerWindow = labels.windowLength * fs;

X = double(data);
switch dataOpts.normalizeBy
  case 'window'
    X = zscore(X);
  case 'all'
    % normalize by whole dataset, rather than by windows
    a = size(X,1);
    b = size(X,2);
    c = size(X,3);
    X = zscore(X(:));
    X = reshape(X,[a,b,c]);
    % windows still have zero mean
    X = bsxfun(@minus,X,mean(X));
  case 'subject'
    % normalize by channel for each subject
    subject = unique(labels.windows.subjectID);
    for m = subject'
      thisIdx = ismember(labels.windows.subjectID,m);
      xThisSubject = X(:,:,thisIdx);
      % windows still have zero mean
      xZeroMean = bsxfun(@minus,xThisSubject,mean(xThisSubject));
      % set Std Dev of each channel to 1
      xZeroMean = reshape(permute(xZeroMean,[1,3,2]),[],nAreas);
      xNorm = bsxfun(@rdivide,xZeroMean,std(xZeroMean));
      X(:,:,thisIdx) = permute(reshape(xNorm,ptsPerWindow,[], ...
        nAreas),[1,3,2]);
    end
  otherwise
    warning('data.normWindows value not recognized. Normalizing by window')
    X = zscore(X);
end

% take Fourier transform
Ns = ceil(ptsPerWindow/2);
xFft = 1/sqrt(ptsPerWindow)*fft(X);
xFft = 2*(xFft(2:Ns+1,:,:));

% Save frequency labels
labels.s = (fs/ptsPerWindow):(fs/ptsPerWindow):ceil(fs/2);

save([saveFile],'dataOpts','labels','xFft','-append')
% save('data_xFft.mat','dataOpts','labels','xFft')
end

