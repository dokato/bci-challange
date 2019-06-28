function [ W, mdata, mWeights] = mccas(data,K,reg,r,weights)
%% regularized-multiset CCA
%   Date           Programmers               Description of change
%   ====        =================            =====================
%  09/10/2016     Qiong Zhang                 Original code
%% Citation
%  Zhang,Q., Borst,J., Kass, R.E., & Anderson, J.A. (2016) Between-Subject
%  Alignment of MEG Datasets at the Neural Representational Space. 

%% INPUT
% data - input training data to CCA (samples * sensors * subjects)
% K - number of CCAs to retain
% reg - add regularization (1) or not (0)
% r - degree of regularization added
% weights - PCA weight maps for each subject

%% OUTPUT
% W - CCA weights that transform PCAs to CCAs for each subject (PCAs * CCAs * subjects)
% mdata - transformed averaged data (CCAs * sapmles * subjects)
% mWeights - projection weights from sensor to CCAs (CCAs * sensors * subjects)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim = size(data,1);
num = size(data,2);
sub = size(data,3);
dim2 = size(weights,1);
num2 = size(weights,2);
sub2 = size(weights,3);
if(K>dim)
    K = dim;
end
temp=[];
for i=1:sub
    temp=[temp;data(:,:,i)];
end
R=cov(temp.');
S = zeros(size(R));
for i = 1:dim*sub
    tmp = ceil(i/dim);
    S((tmp-1)*dim+1:tmp*dim,i) = R((tmp-1)*dim+1:tmp*dim,i); 
end

% add regularization 
if(reg==1)    
    if(K>dim2)
        K = dim2;
    end
    temp=[];
    for i=1:sub2
        temp=[temp;weights(:,:,i)];
    end
    R2=cov(temp.');
    S2 = zeros(size(R2));
    for i = 1:dim2*sub2
        tmp = ceil(i/dim2);
        S2((tmp-1)*dim2+1:tmp*dim2,i) = R2((tmp-1)*dim2+1:tmp*dim2,i); 
    end
    R = R + r*R2;
    S = S + r*S2;
end


% obtain CCA solutions 
[tempW values]=eigs((R-S),S,K);
W = zeros(dim,K,sub);
for i=1:sub
    W(:,:,i)=tempW((i-1)*dim+1:i*dim,:)./norm(tempW((i-1)*dim+1:i*dim,:));
end

% projected data
mdata = zeros(K,num,sub);
for i = 1:sub
    mdata(:,:,i) = W(:,:,i)'*data(:,:,i);
    for j = 1:K
        mdata(j,:,i) = mdata(j,:,i)/norm(mdata(j,:,i));
    end
end


% projection weights
mWeights = 0;
if(reg==1)
    mWeights = zeros(K,num2,sub2);
    for i = 1:sub2
        mWeights(:,:,i) = W(:,:,i)'*weights(:,:,i);
    end
end
end

