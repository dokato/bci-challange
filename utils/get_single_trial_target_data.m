function [X, Y] = get_single_trial_target_data(targetClass,trainData,trainTargets,trainLabels)
%get_single_trial_target_data returns X and Y data for classifier
% for given 
% INPUT:
%    targetClass  - numeric value
%    trainData    - training data
%    trainTargets - target vector 
%    trainLabels  - train labels matrix
% OUTPUT:
%    X - single trials data
%    Y - vector with 0 and 1, where 1 denotes target class

indices = trials_with_target(targetClass,trainLabels);
X = trainData(:,:,indices);
Y = trainTargets(indices);
end

