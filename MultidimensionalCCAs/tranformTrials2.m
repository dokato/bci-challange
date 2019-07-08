function [CCAs] = tranformTrials2(data,prefix,W,mu,sigma,COEFF,KK,K)
%% use of CCA weights (obtained from averaged data) to transform single
%% trial data from sensor space to CCA space
%   Date           Programmers               Description of change
%   ====        =================            =====================
%  09/10/2016     Qiong Zhang                 Original code
%% Citation
%  Zhang,Q., Borst,J., Kass, R.E., & Anderson, J.A. (2016) Between-Subject
%  Alignment of MEG Datasets at the Neural Representational Space. 

%% INPUT
% data - samples x sensors
% prefix - 2 columns: 1) subject index 2) which sample of the trial 
% W - CCA weights that transform PCAs to CCAs for each subject (PCAs * CCAs * subjects)
% For each subject i:
% mu{i} - PCA mean 
% sigma{i} - PCA standard deviation
% COEFF{i} - PCA weights that tranform sensors to PCAs for each subject (sensors * PCAs)

%% OUTPUT
% CCAs - transformed data (previouly in the sensor space, now in the CCA space that have different subjects aligned)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

PCAs = zeros(size(data(:,1:KK)));
CCAs = zeros(size(data(:,1:K)));
i=prefix;

    PCAs = data*COEFF{i}(:,1:KK);
    number = size(CCAs,1); 
    tmu = repmat(mu{i}(1:KK),number,1);
    tsigma = repmat(sigma{i}(1:KK),number,1);
    PCAs= (PCAs-tmu)./tsigma;   
    CCAs= PCAs*W(:,:,i);


end

