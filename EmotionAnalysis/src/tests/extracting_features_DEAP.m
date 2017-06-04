clear;
clc;
TEAP_path = fileparts(pwd);
curr_path = cd;
eval(['cd ' TEAP_path]);
init
eval(['cd ' curr_path]);
% Replace the following line by where your phsyio data is located
physio_path = 'deapdata';
% Replace the following path with your local path of the ratings
feedbacks = readtable('metadata/participant_ratings.csv');
if ~exist([physio_path '/s30_eeglab.mat'],'file')
    loading_DEAP(physio_path);
end
for subject=1:32
    eeglab_file = sprintf('s%0.2d_eeglab.mat',subject);
    bulk = Bulk_load(eeglab_file);
    %exracting EMG feaures
    %TODO extract by subject by epoch
    for epoch =  1:40
        [features(subject,epoch).EMG_feats, features(subject,epoch).EMG_feats_names] = ...
            EMG_feat_extr(bulk(epoch));
        %extracting EEG features
        [features(subject,epoch).EEG_feats, features(subject,epoch).EEG_feats_names] = ...
            EEG_feat_extr(bulk(epoch));
        %extracting GSR features
        [features(subject,epoch).GSR_feats, features(subject,epoch).GSR_feats_names] = ...
            GSR_feat_extr(bulk(epoch));
        %extracting BVP features
        [features(subject,epoch).BVP_feats, features(subject,epoch).BVP_feats_names] = ...
            BVP_feat_extr(bulk(epoch));
        [features(subject,epoch).RES_feats, features(subject,epoch).RES_feats_names] = ...
            RES_feat_extr(bulk(epoch));
        feedback = feedbacks(feedbacks.Participant_id==subject & feedbacks.Experiment_id==epoch,:);
        features(subject,epoch).feedback.felt_arousal = feedback.Arousal;
        features(subject,epoch).feedback.felt_valence = feedback.Valence;
        features(subject,epoch).feedback.felt_dominance = feedback.Dominance;
        features(subject,epoch).feedback.felt_liking = feedback.Liking;
        features(subject,epoch).feedback.felt_familiarity = feedback.Familiarity;
        fprintf('Extracted all the features for subject %d epoch %d\n',subject, epoch);
    end
end

save(['deap_features.mat'],'features');

fprintf('Done! Successfully extracted the feaures\n');
