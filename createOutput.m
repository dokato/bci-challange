subjects = {'01' '02' '03' '04' '05' '06' '07' '08' ...
            '09' '10' '11' '12' '13' '14' '15'};
sessions = { '04' '05' '06' '07'};

targpreds = [];
targpreds_ens = [];
for sb = subjects
    for ss = sessions
        subj = sb{1};
        session = ss{1};
        make_prediction;
        targpreds = [targpreds; mdmTargPred'];
        targpreds_ens = [targpreds_ens; ensTargPred'];
    end
end

%% Saving CSV output file in a proper format
to_save = targpreds;
nrBlocks = size(targpreds,2);

subj_column = reshape(repmat(1:length(subjects),[length(sessions),1]), [length(subjects)*length(sessions),1]);
sess_column = reshape(repmat(1:length(sessions),[length(subjects),1])', [length(subjects)*length(sessions),1]);

to_save = [subj_column sess_column to_save];

colNames = {'SUBJECT', 'SESSION'};
for i=1:nrBlocks
    colNames{i+2} = ['a', num2str(i)];
end
T = array2table(to_save,'VariableNames',colNames);

writetable(T,'out_mdm2.csv','Delimiter',',');
