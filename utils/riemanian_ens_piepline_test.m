function [Yps, Acc, d] = riemanian_ens_piepline_test(Xtst, Ytst, clf, P, Cg, W)
%riemanian_piepline Testing

Xtst = merge_prototype_with_data(Xtst,P);

COVtst = covariances(Xtst,'shcov');

COVtst_gf = geodesic_filter(COVtst,Cg,W(:,1:16-1));

% ensemble of riemanniam features
riem_feat_val = flatten_spd(COVtst_gf)';

[Ypred, d] = test_ensemble(clf, riem_feat_val);
Ypred = Ypred - 1;
Yps = smooth_prediction(-d); % minus, because negative denotes p300 here
Acc = mean(Yps == Ytst);

end

