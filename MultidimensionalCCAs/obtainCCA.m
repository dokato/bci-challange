function [W,mu,sigma,COEFF] = obtainCCA(dataAll,KK,K,reg,l)
%% apply individual-subject PCA and across-subjects CCA
%   Date           Programmers               Description of change
%   ====        =================            =====================
%  09/10/2016     Qiong Zhang                 Original code

%%% INPUT
% dataAll - input data to CCA (samples * sensors * subjects)
% KK - number of PCAs to retain for each subject
% K - number of CCAs to retain 
% reg - whether to add regularization (1/0)
% l - degree of regularization (\lambda)

%%% OUTPUT
% W - CCA weights that transform PCAs to CCAs for each subject (PCAs * CCAs * subjects)
% For each subject i:
% mu{i} - PCA mean 
% sigma{i} - PCA standard deviation
% COEFF{i} - PCA weights that tranform sensors to PCAs for each subject (sensors * PCAs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = [];
dim = size(dataAll,1); % nunber of sensors
num = size(dataAll,2); % number of time points
sub = size(dataAll,3); % number of subjects
weights = zeros(KK,dim,sub);
% obtain subject-specific PCAs
for i = 1:sub
   tmpscore = squeeze(dataAll(:,:,i))';
   mu{i} = mean(tmpscore);
   tmpscore = tmpscore - repmat(mu{i},size(tmpscore,1),1); % centered 
   [COEFF{i}, score] = pca(tmpscore);
   weights(:,:,i) = COEFF{i}(:,1:KK)';
   sigma{i} = sqrt(var(score));
   score = score./repmat(sqrt(var(score)),size(score,1),1); % normalized 
   data = cat(3,data,score');
end

% apply M-CCA
[W,mdata,mw] = mccas(data(1:KK,:,:),K,reg,l,weights);
    
end

