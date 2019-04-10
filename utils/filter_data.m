function [fdata] = filter_data(data, frange, padding)
%plot_gavg_for_target plotting helper function
% By default butterworth filter is used with order determined by function
% constant Forder = 5 (check the code) and sampling rate Fs = 250;
%
% INPUT:
%   target - number from 1-8 denoting target class
%   frange - filter range in Hz, eg. [2 5] Hz.
%   padding - extends data with 0s at the beginning and end to remove
%   filtering effects.
% OUTPUT:
%   fdata - matrix with filtered data

Fs = 250; % - sampling frequency
Forder = 5; % - filter order
% ---
if nargin < 3
    padding = 0;
end

Fn = Fs/2;
wp = frange/Fn;
[bb,aa] = butter(Forder,wp);
dat_length = size(data,2);
fdata = zeros(size(data));
for ch = 1:size(data,1)
    for tr = 1:size(data,3)
        ext_data = [zeros(padding,1)' data(ch,:,tr) zeros(padding,1)'];
        fdata(ch,:,tr) = filtfilt(bb,aa,ext_data(padding+1:padding+dat_length));
    end
end

end

