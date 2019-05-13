function plotSignal(X, titleTop)
%plotSignal simple ERP plot from 8 channels
% INPUT:
%    X - matrix with singal (channel x time points)
%    - titleTop - upper title

if nargin < 2
    titleTop = 'Signal';    
end

nrChannels = size(X,1);
sigLen = size(X,2);

f = figure;
for ii = 1: nrChannels
    subplot(nrChannels,1,ii)
    plot(1:sigLen, X(ii,:))
    if ii == 1
       title(titleTop); 
    end
end
set(gcf, 'Position',  [100, 400, 300, 800])

end

