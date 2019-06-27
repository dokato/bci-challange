% Attempt to do p300 prediction with Riemannian geometry approach
%addpath('utils/')
% add covariance toolbox to path as well
%clear all

% data reading
%%%%%%%%%%%%%%%%
subj = '11';
session = '03';
data_load;
%%%%%%%%%%%%%%%%


trainDataf = filter_data(trainData,[1,15],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);

trainDatac = select_time_window(trainDatab, [0.0, 0.6]);
%trainDataz = zscore_by_trials(trainDatac);
% trainData after preprocessing goes here;
trainDataP = trainDatac;

[Xtr, Ytr, Xval, Yval, selBlocks] = split_to_train_test(trainDataP,trainTargets,trainLabels);

P = make_prototype(Xtr,Ytr);

Xtr = merge_prototype_with_data(Xtr,P);
Xval = merge_prototype_with_data(Xval,P);

COV = covariances(Xtr,'shcov');
COVval = covariances(Xval);

[W,Cg] = fgda(COV,Ytr,'riemann',{},'shcov',{});
COV_gf = geodesic_filter(COV,Cg,W(:,1:16-1));
COVval_gf = geodesic_filter(COVval,Cg,W(:,1:16-1));
if ~isreal(Cg)
    disp(['not real... ' subj ' ' session])
end

% standard mdm procedure
[Ypred, d, C] = mdm(COVval_gf,COV_gf,Ytr,'riemann','riemann');
Yps = smooth_prediction(d);
Acc = mean(Yps==Yval);

% ensemble of riemanniam features
riem_feat = flatten_spd(COV_gf)';
riem_feat_val = flatten_spd(COVval_gf)';

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

[Ypred, d] = test_ensemble(ensemble_clf, riem_feat_val);
Ypred = Ypred - 1;
Yps = smooth_prediction(-d); % minus, because negative denotes p300 here
Acc_ens = mean(Yps==Yval)

[p,r,f1] = get_precision_recall(Yps, Yval);

%param = mv_get_classifier_param('lda');
%lda_cf = train_lda(param, squeeze(mean(Xtr(9:end,:,:),1))', Ytr+1);
%[predlabel, dval] = test_lda(lda_cf, squeeze(mean(Xval(9:end,:,:),1))');
%Yps_2 = smooth_prediction(-dval);
%Acc_lda = mean(Yps_2==Yval)
%[p,r,f1] = get_precision_recall(Yps_2, Yval)

%% PLOT WRONG CLASSIFICATION

%wrongSigs = Xval(9:end,:,Yps~=Yval);
%wrongLabs = Yps~=Yval;
%for tt = 1: size(wrongSigs,3)
%    plotSignal(squeeze(wrongSigs(:,:,tt)), ['TL: ' num2str(wrongLabs(tt))])
%    saveas(gcf,['tmp/' num2str(tt) '.png'])
%    close all
%end