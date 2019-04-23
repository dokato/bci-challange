function [flatSPD] = flatten_spd(SPD)
%FLATTEN_SPD vectorize (make flat) symmetric positive definite (SPD) matrix
%            trials by trials
% INPUT:
%    SPD - symmetric positive definite matrix (n, n, trials). 
% OUTPUT:
%    flatSPD - flatSPD (n * (n+1) / 2, trials)

n_channels = size(SPD,1);
n_trials = size(SPD,3);
flatSPD = zeros(n_channels*(n_channels+1)/2, n_trials);
for tt=1:n_trials
    m = SPD(:,:,tt);
    flatSPD(:,tt) = m(triu(true(size(m))));
end

end
