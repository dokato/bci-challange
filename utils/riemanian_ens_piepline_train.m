function [ensemble_clf, P, Cg, W] = riemanian_ens_piepline_train(Xtr, Ytr, cfg)
%riemanian_piepline Training
    P = make_prototype(Xtr,Ytr);
    
    Xtr = merge_prototype_with_data(Xtr,P);
    COV = covariances(Xtr);
    [W,Cg] = fgda(COV,Ytr,'riemann',{},'shcov',{});
    COV_gf = geodesic_filter(COV,Cg,W(:,1:16-1));

    % ensemble of riemanniam features
    riem_feat = flatten_spd(COV_gf)';
    ensemble_clf = train_ensemble(cfg,riem_feat,Ytr+1);
end

