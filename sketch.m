addpath('utils/')
subj = '15';

load(['data/SBJ' subj '/SBJ' subj '/S01/Test/testData.mat'])
load(['data/SBJ' subj '/SBJ' subj '/S01/Test/testEvents.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S01/Test/runs_per_block.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S01/Train/trainData.mat'])
load(['data/SBJ' subj '/SBJ' subj '/S01/Train/trainEvents.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S01/Train/trainLabels.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S01/Train/trainTargets.txt'])

xtime = -0.2 + (1:350)/250;

subplot(211)
plot(xtime, squeeze(mean(mean(trainData(:,:,trainTargets==1),3),1)))
title('targets')
ylim([-6 6])
subplot(212)
plot(xtime, squeeze(mean(mean(trainData(:,:,trainTargets==0),3),1)))
title('no targets')
ylim([-6 6])
saveas(gcf, ['figs/', subj, '_grandavg.png'])
close all;

for targ = 1:8
    plot_gavg_for_target(targ, trainLabels, trainData, trainTargets)
    saveas(gcf, ['figs/', subj, '_avg_target_' num2str(targ) '.png'])
    close all;
end

signalsBlock20 = split_test_by_target(20,trainData,trainEvents, 10);
cc = 1;
for ch = 1:8 % channels
    for tg = 1:8 % classes
        subplot(8,8,cc)
        plot(xtime, squeeze(signalsBlock20(tg,ch,:)))
        xlim([-0.2 1.5])
        if ch == 1
           title(['class: ' num2str(tg)]) 
        end
        if tg == 1
           ylabel(['channel: ' num2str(ch)]) 
        end
        cc = cc + 1;
    end
end

