% Attempt to do p300 prediction with Riemannian geometry approach
addpath('utils/')
% add covariance toolbox to path as well
clear all

% data reading
%%%%%%%%%%%%%%%%
subj = '10';
session = '01';
data_load;
%%%%%%%%%%%%%%%%


trainDataf = filter_data(trainData,[1,15],20);
trainDatab = remove_baseline(trainDataf,[-0.2, 0.0]);

trainDatac = select_time_window(trainDatab, [0.0, 0.5]);

% trainData after preprocessing goes here;
trainDataP = trainDatac;

[Xtr, Ytr, Xval, Yval] = split_to_train_test(trainDataP,trainTargets,trainLabels);

P = make_prototype(Xtr,Ytr);

Xtr = merge_prototype_with_data(Xtr,P);
Xval = merge_prototype_with_data(Xval,P);

COV = covariances(Xtr);
COVval = covariances(Xval);

[W,Cg] = fgda(COV,Ytr,'riemann',{},'shcov',{});
COV_gf = geodesic_filter(COV,Cg,W(:,1:2-1));
COVval_gf = geodesic_filter(COVval,Cg,W(:,1:2-1));    

[Ypred, d, C] = mdm(COVval_gf,COV_gf,Ytr,'riemann','riemann');

Yps = smooth_prediction(d);

mean(Ypred==Yval)

mean(Yps==Yval)
