%script that load data from subj and session information
% it creates time axis xtime as well
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Test/testData.mat'])
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Test/testEvents.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Test/runs_per_block.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Train/trainData.mat'])
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Train/trainEvents.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Train/trainLabels.txt'])
load(['data/SBJ' subj '/SBJ' subj '/S' session '/Train/trainTargets.txt'])

xtime = -0.2 + (1:350)/250;