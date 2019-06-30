% Make final predictions
%clear all

% data reading
%%%%%%%%%%%%%%%%
%subj = '04';
%session = '03';
data_load;
%%%%%%%%%%%%%%%%

cfg = [];
cfg.strategy = 'dval';
cfg.nsamples = 0.4;
cfg.nfeatures = 0.6;
cfg.nlearners = 400;
cfg.stratify = 1;
cfg.bootstrap = 1;
cfg.learner = 'lda';
cfg.learner_param = []; %.reg = 'l2';
%cfg.learner_param.lambda = [0.1, 0.01, 1];
cfg.simplify = 0;

%% Different preprocessing methods

%1 all electrodes broad band
trainDataf = filter_data(trainData,[1,16],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
trainDatac = select_time_window(trainDatab, [0.0, 0.6]);
trainData1 = trainDatac;

testDataf = filter_data(testData,[1,16],20);
testDatab = remove_baseline(testDataf,[-0.2, 0.0]);
testDatac = select_time_window(testDatab, [0.0, 0.6]);
testData1 = testDatac;

%2  central elec broad band
trainData2 = trainDatac(1:4,:,:);
testData2 = testDatac(1:4,:,:);

%3  posterior elec broad band
trainData3 = trainDatac(5:8,:,:);
testData3 = testDatac(5:8,:,:);

%4  all electrodes low pass
trainDataf = filter_data(trainData,[1,8],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
trainDatac = select_time_window(trainDatab, [0.0, 0.6]);
trainData4 = trainDatac;

testDataf = filter_data(testData,[1,8],20);
testDatab = remove_baseline(testDataf,[-0.2, 0.0]);
testDatac = select_time_window(testDatab, [0.0, 0.6]);
testData4 = testDatac;

%5  central elec  low pass
trainData5 = trainDatac(1:4,:,:);
testData5 = testDatac(1:4,:,:);

%6  posterior elec low pass
trainData6 = trainDatac(5:8,:,:);
testData6 = testDatac(5:8,:,:);

%7  all electrodes whole time
trainDataf = filter_data(trainData,[1,16],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
trainData7 = trainDatab;

testDataf = filter_data(testData,[1,16],20);
testDatab = remove_baseline(testDataf,[-0.2, 0.0]);
testData7 = testDatab;

%8  Raw data
trainData8 = trainData;
testData8 = testData;

clear trainDataf trainDatab trainDatac testDataf testDatab testDatac

%% Training and validation

%1
X = trainData1; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData1;
Yval = zeros(size(testData,3),1);
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d1] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d1] = mdm_piepline_train(Xtr, Ytr, Xval);

%2
X = trainData2; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData2;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d2] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d2] = mdm_piepline_train(Xtr, Ytr, Xval);

%3
X = trainData3; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData3;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d3] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d3] = mdm_piepline_train(Xtr, Ytr, Xval);

%4
X = trainData4; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData4;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d4] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d4] = mdm_piepline_train(Xtr, Ytr, Xval);

%5
X = trainData5; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData5;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d5] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d5] = mdm_piepline_train(Xtr, Ytr, Xval);

%6
X = trainData6; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData6;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d6] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d6] = mdm_piepline_train(Xtr, Ytr, Xval);

%7
X = trainData7; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData7;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d7] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d7] = mdm_piepline_train(Xtr, Ytr, Xval);

%8
X = trainData8; Y = trainTargets;
Xtr = X;
Ytr = Y;
Xval = testData8;
[ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg);
[Yps, Acc, d8] = riemanian_ens_piepline_test(Xval, Yval, ensemble_clf, P, Cg, W);
%[Yps, d8] = mdm_piepline_train(Xtr, Ytr, Xval);

bigD = d1+d2+d3+d4+d5+d6+d7+d8;

Yps = smooth_prediction(-bigD);

ensTargPred = predict_target(testEvents, Yps, runs_per_block);
ensTargPred2 = predict_accumulative(testEvents, -bigD, runs_per_block);
