function [p,r,f1] = get_precision_recall(Ypred,Ytrue)
%GET_PRECISION_RECALL Gives acc measures for binary vectors
% INPUT:
%   Ypred - predicted vector
%   Ypred - true vector
% OUTPUT:
%   precision, recall and F1
CM = confusionmat(Ypred,Ytrue);

t_neg = CM(1,1);
t_pos = CM(2,2);
f_neg = CM(1,2);
f_pos = CM(2,1);

p = t_pos/(t_pos+f_pos);% precison
r = t_pos/(t_pos+f_neg);% recall
f1 = 2*p*r/(p+r); % F1
end

