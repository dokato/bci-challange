% Attempt to reproduce a Barachant 'A Plug&Play [...]' - binary
% classification
addpath('utils/')
clear all

% !!! Do you have covariancetoolbox added to your path?

% data reading
%%%%%%%%%%%%%%%%
subj = '01';
session = '01';
data_load;
%%%%%%%%%%%%%%%%

% ++++++++++++++++++++++++++++++ for specific target

% we select all trials from blocks where target was displayed
% X contais 8 channels, 350 points data
% Y is target with 0/1

% preprocessing
X = trainData;
Y = trainTargets;
Xf = filter_data(X,[1,15],20);
Xb = remove_baseline(Xf,[-0.2, -0.1]);


% split train test
trainProportion = 0.8;
splitP = round(trainProportion*size(X,3));
Xr = Xb(:,:,splitP+1:end);
Yr = Y(splitP+1:end);

Xtst = Xb(:,:,1:splitP);
Ytst = Y(1:splitP);

% at this point X should be ready in preprocessed form
% all below operations are done on Xr and Yr

figure;
hold on;
for ch=1:8
    subplot(8,2,2*ch-1)
    plot(xtime, squeeze(mean(Xr(ch,:,find(Yr==1)),3)))
    ylim([-12,12])
end
for ch=1:8
    subplot(8,2,2*ch)
    plot(xtime, squeeze(mean(Xr(ch,:,find(Yr==0)),3)))
    ylim([-12,12])
end
hold off;

% compute covariance matrices for all trials
covTrials = zeros(16,16,size(Xr,3));
prototypeX = mean(Xr(:,:,find(Yr==1)),3);
for tr = 1:size(Xr,3)
    % TODO regularized cov ?
    % TODO temporal window selection ?
    trialTS = [prototypeX ; Xr(:,:,tr)];
    covTrials(:,:,tr) = cov(squeeze(trialTS)');
end

[COV, P] = covariances_p300(Xr,Yr,'aaaa',{}); % with 'aaaa' this is normal matlab cov

geoMeanT = geodesic_mean(COV(:,:,Yr==1),'riemann');
geoMeanNT = geodesic_mean(COV(:,:,Yr==0),'riemann');

Yp = zeros(size(Yr));
for tr = 1:size(Xr,3)
    % Eq. 14 from Barachant 'A Plug&Play [...]'
  s = distance_riemann(geoMeanNT,squeeze(COV(:,:,tr))) - ...
     distance_riemann(geoMeanT,squeeze(COV(:,:,tr)));
  Yp(tr) = s > 0;
end

disp('Train ACC')
sum(Yr==Yp)/length(Yr)

% test
covTestTrials = zeros(16,16,size(Xtst,3));
Ytstp = zeros(size(Ytst));
for tr = 1:size(Xtst,3)
  trialTS = [prototypeX ; Xtst(:,:,tr)];
  covTestTrials(:,:,tr) = cov(squeeze(trialTS)');
  s = distance_riemann(geoMeanNT,squeeze(covTestTrials(:,:,tr))) - ...
     distance_riemann(geoMeanT,squeeze(covTestTrials(:,:,tr)));
  Ytstp(tr) = s > 0;
end

disp('Test ACC')
sum(Ytstp==Ytst)/length(Ytst)
