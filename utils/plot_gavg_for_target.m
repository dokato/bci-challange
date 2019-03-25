function plot_gavg_for_target(target, trainLabels, trainData, trainTargets)
%plot_gavg_for_target plotting helper function
% INPUT:
%   target - number from 1-8 denoting target class
%   trainLabels - matrix from training data
%   trainData - matrix with training data
%   trainTargets - vector with targets
xtime = -0.2 + (1:350)/250;

trainDataSpec = trainData(:, :, trials_with_target(target,trainLabels));
trainTargetsSpec = trainTargets(trials_with_target(target,trainLabels));

subplot(211)
plot(xtime, squeeze(mean(mean(trainDataSpec(:,:,trainTargetsSpec==1),3),1)))
title(['target:' num2str(target)])
ylim([-7 7])
subplot(212)
plot(xtime, squeeze(mean(mean(trainDataSpec(:,:,trainTargetsSpec==0),3),1)))
title('others')
ylim([-7 7])

end

