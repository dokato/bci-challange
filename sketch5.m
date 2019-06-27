% Riemanian ensemble with multiple filtering, electr selections
%addpath('utils/')
% add covariance toolbox to path as well
clear all

% data reading
%%%%%%%%%%%%%%%%
subj = '11';
session = '03';
data_load;
%%%%%%%%%%%%%%%%

%Split data to train/test
[trainIndices, testIndices] = split_to_train_test_indices(trainData,trainTargets,trainLabels);

% Classifier parameters

cfg = [];
cfg.strategy = 'dval';
cfg.nsamples = 0.4;
cfg.nfeatures = 0.6;
cfg.nlearners = 400;
cfg.stratify = 1;
cfg.bootstrap = 1;
cfg.learner = 'lda';
cfg.learner_param = [];
cfg.simplify = 0;

%% Different preprocessing methods

%1 all electrodes broad band
trainDataf = filter_data(trainData,[1,16],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
trainDatac = select_time_window(trainDatab, [0.0, 0.6]);
trainData1 = trainDatac;

%2  central elec broad band
trainData2 = trainDatac(1:4,:,:);

%3  posterior elec broad band
trainData3 = trainDatac(5:8,:,:);

%4  all electrodes low pass
trainDataf = filter_data(trainData,[1,8],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
trainDatac = select_time_window(trainDatab, [0.0, 0.6]);
trainData4 = trainDatac;

%5  central elec  low pass
trainData5 = trainDatac(1:4,:,:);

%6  posterior elec low pass
trainData6 = trainDatac(5:8,:,:);

%7  all electrodes whole time
trainDataf = filter_data(trainData,[1,15],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
trainData7 = trainDatab;

%8  Raw data
trainData8 = trainData;

clear trainDataf trainDatab trainDatac

%% Training and validation

%1
X = trainData1; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d1] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%2
X = trainData2; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d2] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%3
X = trainData3; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d3] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%4
X = trainData4; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d4] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%5
X = trainData5; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d5] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%6
X = trainData6; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d6] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%7
X = trainData7; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d7] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

%8
X = trainData8; Y = trainTargets;
Xtr = X(:,:,trainIndices);
Ytr = Y(trainIndices);
Xval = X(:,:,testIndices);
Yval = Y(testIndices);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d8] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);

bigD = d1+d2+d3+d4+d5+d6+d7+d8;

Yps = smooth_prediction(-bigD);
Acc = mean(Yps == Yval)

[p,r,f1] = get_precision_recall(Yps, Yval)
