function [predTargets] = predict_target(events, Ybin, runs_per_block)
%predict_target - predict a final target per block based on binary ERP
%existance prediction. The most frequent occurence of event per block wins.
%
% INPUT:
%    events - vector with event displayed on the screen
%    Ybin - binary prediction of ERP existence
%    runs_per_block - integer with run per block
%    dvals - matrix of distances to classes. Can be of a shape: 
%        (trials, 2 ) - Column  1 - distance to p300, Column 2 - not target  or  
%        (trials, 1 ) - negative distance to 1, positive to 0
% OUTPUT:
%    predTargets - predicted class per block (blocks,1)

if nargin < 3
    runs_per_block = 10; % for training /validation set. For test, change this!
end

nr_events = 8;

nrBlocks = size(events,1)/(runs_per_block * nr_events);

predTargets = zeros(nrBlocks, 1);
for ii=1:nrBlocks
    blockIndices = ((ii - 1)*runs_per_block*nr_events+1): (ii*runs_per_block*nr_events);
    blockEvents = events(blockIndices);
    erpPred = Ybin(blockIndices);
    cnts = hist(blockEvents(logical(erpPred)),1:nr_events);
    [~,im] = max(cnts);
    predTargets(ii) = im;
end

end

