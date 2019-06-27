% Make final predictions
%clear all

% data reading
%%%%%%%%%%%%%%%%
%subj = '04';
%session = '03';
data_load;
%%%%%%%%%%%%%%%%


% data preprocessing
trainDataf = filter_data(trainData,[1,16],20);
testDataf = filter_data(testData,[1,16],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);
testDatab = remove_baseline(testDataf,[-0.2, 0.0]);
trainDatac = select_time_window(trainDatab, [0.0, 0.6]);
testDatac = select_time_window(testDatab, [0.0, 0.6]);

% trainData after preprocessing goes here;
trainDataP = trainDatac;
testDataP = testDatac;

clear testDataf trainDataf testDatab trainDatab testDatac trainDatac

% Classifier training
Xtr = trainDataP;
Ytr = trainTargets;
Xtest = testDataP;

P = make_prototype(Xtr,Ytr);

Xtr = merge_prototype_with_data(Xtr,P);
Xtest = merge_prototype_with_data(Xtest,P);

COV = covariances(Xtr);
COVtest = covariances(Xtest);

[W,Cg] = fgda(COV,Ytr,'riemann',{},'shcov',{});
COV_gf = geodesic_filter(COV,Cg,W(:,1:16-1));
COVtest_gf = geodesic_filter(COVtest,Cg,W(:,1:16-1));    

% standard mdm procedure
[Ypred, d, C] = mdm(COVtest_gf,COV_gf,Ytr,'riemann','riemann');
Yps = smooth_prediction(d);
mdmTargPred = predict_accumulative(testEvents, d, runs_per_block);

% ensemble of riemanniam features
riem_feat = flatten_spd(COV_gf)';
riem_feat_test = flatten_spd(COVtest_gf)';

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
ensemble_clf = train_ensemble(cfg,riem_feat,Ytr+1);

[Ypred, d] = test_ensemble(ensemble_clf, riem_feat_test);
Ypred = Ypred - 1;

Yps = smooth_prediction(-d);

ensTargPred = predict_target(testEvents, Yps, runs_per_block);