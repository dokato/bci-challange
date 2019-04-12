function [tcdata] = select_time_window(data,timerange)
%SELECT_TIME_WINDOW select time points from the second dimension of the
%data matrix
% INPUT:
%    data - matrix with training data (channels, time points, trials)
%    timerange - vector with baseline time range to remove, eg. [-0.1 0]
% OUTPUT:
%    tcdata - matrix (channels, selected time points, trials)

xtime = -0.2 + (1:350)/250;
% ---

id_s = find(xtime >= timerange(1));
id_e = find(xtime >= timerange(2));

tcdata = data(:,id_s(1):id_e(1),:);

end

