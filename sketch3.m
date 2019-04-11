% Attempt to do multiclass analysis with Riemannian geometry approach
addpath('utils/')
% add covariance toolbox to path as well
clear all

% data reading
%%%%%%%%%%%%%%%%
subj = '10';
session = '01';
data_load;
%%%%%%%%%%%%%%%%

ntCOVs = [];
for tl = unique(trainLabels)'
   [X, Y] = get_single_trial_target_data(tl,trainData,trainTargets,trainLabels);
   %Xf = filter_data(X,[1,15],20);
   %Xb = remove_baseline(Xf,[-0.2, -0.1]);
   [COV, P] = covariances_p300(X,Y,'aa',{});
   geoMeanT = geodesic_mean(COV(:,:,Y==1),'riemann');
   patterns.(['p' num2str(tl)]) = P;
   geomeans.(['p' num2str(tl)]) = geoMeanT;
   ntCOVs = [ntCOVs; permute(COV(:,:,Y==0), [3 1 2])];
end

predLabels = zeros(20,1);
for bb = 1 : 20 % number of blocks in training set
    %trainDataf = filter_data(trainData,[1,15],20);
    %trainDatab = remove_baseline(trainDataf,[-0.2, -0.1]);
    [blockSig] = split_test_by_target(bb, trainData,trainEvents, 10);

    vecS = zeros(size(unique(trainLabels)));
    for tl = unique(trainLabels)'
      trialTS = [patterns.(['p' num2str(tl)]) ; squeeze(blockSig(tl,:,:))];
      covTestTrial = cov(squeeze(trialTS)');
      s = distance_riemann(geomeans.(['p' num2str(tl)]), covTestTrial);
      vecS(tl) = s;
    end

    [val, ind] = max(vecS);
    predLabels(bb) = ind;
end

sum(predLabels == trainLabels) / 20
