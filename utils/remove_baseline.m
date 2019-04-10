function [bcdata] = remove_baseline(data,timerange)
%remove_baseline removes baseline from data.
%  Assumes that data has temporal dimension 2.
%  Also, assumes that time vector of data is -0.2 + (1:350)/250;
% (look at beggining of func for details).
% INPUT:
%   data - matrix with dimensions:
%            channels x time points x trials
%   timerange - vector with baseline time range to remove, eg. [-0.1 0]
% OUTPUT:
%   bcdata - baseline corrected data (same size as data)

xtime = -0.2 + (1:350)/250;
% ---

id_s = find(xtime>=timerange(1));
id_e = find(xtime>=timerange(2));

bl_means = mean(data(:,id_s(1):id_e(1),:),2);
bcdata = data - repmat(bl_means, [1 length(xtime) 1]);
end

