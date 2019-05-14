function [predTargets] = predict_accumulative(events, d, runs_per_block)
%predict_accumulative predict a final target per block based on binary ERP
%existance prediction. The event with highest accumulated evidence (d)
%wins.
%
% INPUT:
%    runs_per_block - integer with run per block
%    dvals - matrix of distances to classes. Can be of a shape: 
%        (trials, 2 ) - Column  1 - distance to p300, Column 2 - not target  or  
%        (trials, 1 ) - negative distance to 1, positive to 0
% OUTPUT:
%    predTargets - predicted class per block (blocks,1)

if nargin < 2
    runs_per_block = 10;
end

nr_events = 8;

if size(d,2) == 2
    dd = d(:,1)-d(:,2);
else
    dd = d;
end

nrBlocks = size(events,1)/(runs_per_block * nr_events);

predTargets = zeros(nrBlocks, 1);

for ii=1:nrBlocks
    blockIndices = ((ii - 1)*runs_per_block*nr_events+1): (ii*runs_per_block*nr_events);
    accumInfo = zeros(nr_events,1);
    for bi = blockIndices
        accumInfo(events(bi)) = accumInfo(events(bi)) + dd(bi);
    end
    [~,mix] = max(accumInfo);
    predTargets(ii) = mix;
end

end

