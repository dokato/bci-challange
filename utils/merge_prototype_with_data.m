function [extData] = merge_prototype_with_data(data,prototype)
%MERGE_PROTOTYPE_WITH_DATA merges prototype from e.g. MAKE_PROTOTYPE
%function with data
% INPUT:
%    data - matrix with training data (channels, time points, trials)
%    prototype - matrix (channels, time points)
% OUTPUT:
%   extData - extended data (2*channels, time points, trials)

extData = zeros(2*size(data,1),size(data,2),size(data,3));

for tr=1:size(data,3)
    extData(1:size(data,1),:,tr) = prototype;
    extData(size(data,1)+1:end,:,tr) = data(:,:,tr);
end

end

