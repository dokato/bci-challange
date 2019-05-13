function [trainIndices, testIndices] = split_to_train_test_indices(trainData, trainTargets,trainLabels, proportion)
%SPLIT_TO_TRAIN_TEST Splits data into training and test (validation) sets
% INPUT:
%    trainData - matrix with training data (channels, time points, trials)
%    trainTargets - binary vector of 0/1 (trials)
%    trainLabels  - train labels matrix
%    proportion - int denoting split proportion (%)
%                 (default 80 - percent of training data)
% OUTPUT:
%    Indices of training and test samples;

if nargin < 4
    proportion = 80;
end

proportion = proportion/100;
nrOfBlocksInValSet = round(20*(1-proportion));


[counts, uniqueLabels] = hist(trainLabels,unique(trainLabels));
testTrials = [];
trainLabelsTMP = trainLabels;
prevCands = [];
for ii = 1:nrOfBlocksInValSet
    cand = 0; % candidate block 1-20
    while cand==0
        cand = randi(length(trainLabels));
        if ~isempty(intersect(cand,prevCands))
           cand = 0;
           continue;
        end
        if counts(find(uniqueLabels==trainLabels(cand))) <= 1
            cand = 0;
        else
            counts(find(uniqueLabels==trainLabels(cand))) = counts(find(uniqueLabels==trainLabels(cand))) - 1;
            prevCands = [prevCands cand];
        end
    end
    testTrials = [testTrials ((cand - 1)*80+1): (cand*80)];
end
testTrials = testTrials';
testIndices = zeros(size(trainData,3),1);
testIndices(testTrials) = 1;
trainIndices = testIndices*-1+1;

testIndices = logical(testIndices);
trainIndices = logical(trainIndices);
end
