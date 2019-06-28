%% If you run his function with PCA and CCA
% no regularization
[W,mu,sigma,COEFF] = obtainCCA(data,8,7,0,0); %8 PCAs, 7 CCAs
% regularization
l = [0,10,20,50,100,200,500];
for ii=1:numel(ii)
    [W,mu,sigma,COEFF] = obtainCCA(data,8,7,1,l(ii));
    % and so on...
end

%% If you dont use PCAs
[W1,mdata]=adaptedMCCAS(data,7);

%% started to adapt a function to transform single-trial data from sensor dimensions to CCAs 
%mu, sigma, coeff is using PCAs
for trial=1:Ntrials
    CCAs(trial,:,:) =tranformTrials2(squeeze(Data(:,:,trial))',subject,W,...
        mu,sigma,coeff,8,7);
end