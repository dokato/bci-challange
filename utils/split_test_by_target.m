function [blockSignals] = split_test_by_target(block, testData,testEvents, runs_per_block, plotflag)
%split_test_by_target - for given block it takes out all trials for given
%events and averages them out and returns as a matrix.
%
% INPUT:
%   block - number of block to retrieve data from
%   testData - matrix with test data
%   testEvents - vector with events code
%   runs_per_block - number of runs per block
%   plotflag - flag sayin whether to plot or not avg over electrode subplots
% OUTPUT:
%   blockSignals - matrix with events signals averaged 
%                  (events, channel, time)
if nargin < 5
    plotflag = 0;
end
blockData = testData(:,:,((block-1)*8*runs_per_block)+1:(block*runs_per_block*8));
blockEvents = testEvents(((block-1)*8*runs_per_block)+1:(block*runs_per_block*8));
blockSignals = zeros(8, 8, 350);
for tt=1:8
    blockSignals(tt,:,:) = squeeze(mean(blockData(:,:,find(blockEvents==tt)),3));
end

if plotflag
   xtime = -0.2 + (1:350)/250;
   for tt=1:8
       subplot(4,2,tt)
       plot(xtime, squeeze(mean(blockSignals(tt,:,:),2)));
       title(num2str(tt))
       ylim([-10 10])
   end
end
end
