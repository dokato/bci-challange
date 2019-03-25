function [trials] = trials_with_target(targetClass,trainLabels)
%trials_with_target returns indices of trials
% INPUT:
%    targetClass - numeric value
%    trainLabels  - train labels matrix
% OUTPUT:
%    trials - vector with trials from targetClass block
%             (should be multiplier of 10)

indices = find(trainLabels==targetClass);
trials = [];
for ii=indices'
    trials = [trials ((ii - 1)*80+1): ii*80];
end
end

