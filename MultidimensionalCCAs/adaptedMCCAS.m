function [W,mdata]=adaptedMCCAS(data,K)
% data: samples by channels by subjects (averaged of all target trials together and
% then the average of all non-target trials together)
% K: no CCAs to retain (7: N channels -1)

%% output:
% W: CCA weights (sensors x CCAS x subjects)
% mdata: transformed averaged data (CCAs*samples*subjects)

%% preparing
[NoSamp,NoSen,NoSub]=size(data);
if (K>NoSamp),K=NoSamp;end
temp=[];
for s=1:NoSub
    temp=[temp;data(:,:,s)];
end
%covariance matrix
R=cov(temp.');
S=zeros(size(R));
for i = 1:NoSamp*NoSub
    tmp = ceil(i/NoSamp);
    S((tmp-1)*NoSamp+1:tmp*NoSamp,i) = R((tmp-1)*NoSamp+1:tmp*NoSamp,i); 
end
%% obtain CCA solutions 
[tempW,~]=eigs((R-S),S,K);
W = zeros(NoSamp,K,NoSub);
for i=1:NoSub
    W(:,:,i)=tempW((i-1)*NoSamp+1:i*NoSamp,:)./norm(tempW((i-1)*NoSamp+1:i*NoSamp,:));
end
%% projected data
mdata = zeros(K,NoSen,NoSub);
for i = 1:NoSub
    mdata(:,:,i) = W(:,:,i)'*data(:,:,i);
    for j = 1:K
        mdata(j,:,i) = mdata(j,:,i)/norm(mdata(j,:,i));
    end
end



