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

poly_order = 8;

if strcmp(type,'mean')
    prototype = mean(data(:,:,Y==1),3);
elseif strcmp(type,'poly')
    prototype = mean(data(:,:,Y==1),3);
    xx = 1:size(prototype,2);
    newprot = zeros(size(prototype));
    for ch = 1:size(prototype,1)
        p = polyfit(xx,squeeze(prototype(ch,:)),poly_order);
        yPoly = polyval(p,xx);
        newprot(ch,:) = yPoly;
    end
    prototype = newprot;
else
   error('not recognized prototype type') 
end
end
