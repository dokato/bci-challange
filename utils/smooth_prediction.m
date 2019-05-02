function [Ypred] = smooth_prediction(d)
%SMOOTH_PREDICTION Summary of this function goes here
% INPUT:
%    d - matrix of distances to classes. Can be of a shape: 
%        (trials, 2 ) - Column  1 - distance to p300, Column 2 - not target  or  
%        (trials, 1 ) - negative distance to 1, positive to 0
% OUTPUT:
%    Ypred - smooth Ypred vector (trials,1)

if nargin < 2
    runs_per_block = 10; % for training /validation set. For test, change this!
end

Ypred = zeros(size(d,1),1);

if size(d,2) == 2
    dd = d(:,1)-d(:,2);
else
    dd = d;
end

for ii=1:(size(d,1)/8)
    run_indices = ((ii - 1)*8+1): (ii*8);
    [~,mix] = max(dd(run_indices));
    Ypred(run_indices(mix)) = 1;
end

end

