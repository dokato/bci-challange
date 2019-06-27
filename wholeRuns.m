%subjects = {'01' '02' '03' '04' '05' '06' '07' '08' ...
%            '09' '10' '11' '12' '13' '14' '15'};
sessions = { '01' '02' '03'};
subjects = {'01' '11'};

preds = [];
preds_ens = [];
ff_ens = [];
for sb = subjects
    for ss = sessions
        subj = sb{1};
        session = ss{1};
        sketch4;
        preds = [preds Acc];
        preds_ens = [preds_ens Acc_ens];
        ff_ens = [ff_ens f1];
    end
end
mean(preds_ens)
mean(preds)