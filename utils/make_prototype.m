function [prototype] = make_prototype(data,Y,type)
%MAKE_PROTOTYPE make p300 prototype
% INPUT:
%    data - matrix with training data (channels, time points, trials)
%    Y - binary vector of 0/1 (trials)
%    type      - method of creating prototype ('mean' is default)
% OUTPUT:
%    prototype - matrix (channels, time points)
if nargin < 3
    type = 'mean';
end

if strcmp(type,'mean')
    prototype = mean(data(:,:,Y==1),3);
else
   error('not recognized prototype type') 
end
end
