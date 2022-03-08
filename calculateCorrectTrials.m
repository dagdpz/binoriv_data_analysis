function calculateCorrectTrials(filename)

% This script calculates performance for 8 types of trials in the binoriv
% task for monkeys and plots them into 4 subplots depending on the fixation
% spot location
% 
% Example use:
% calculateCorrectTrials('Y:\Data\Linus\20220301\Lin2022-03-01_02.mat')
%

% load eye-tracker data file
load(filename, 'trial')

% extract fix spot positions and color
trial_info = [];
for ii = 1:length(trial) 
    trial_info(ii, :) = [trial(ii).eye.fix.pos(1:2) trial(ii).eye.fix.color_dim]; 
end

[unqConditions, ~, conditionIds] = unique(trial_info, 'rows');

rewarded_trial_ids = [trial.rewarded] == 1; % rewarded trials
aborted_trial_ids = cellfun(@ (x) strcmp(x, 'ABORT_EYE_FIX_HOLD_STATE'), {trial.abort_code});

for conditionNum = 1:size(unqConditions, 1)

    currConditionIds = conditionIds == conditionNum;
    
    % find rewarded trials of the current condition
    currConditionRewarded = currConditionIds & rewarded_trial_ids';
    
    % find aborted trials of the current condition
    currConditionAborted = currConditionIds & aborted_trial_ids';
    
    rewarded_portion(conditionNum) = sum(currConditionRewarded)/(sum(currConditionRewarded) + sum(currConditionAborted));
    
end

color_data = [0 0 1; 1 0 0];
y_labels = 0:0.1:1;

figure,

subplot(2, 2, 1)
b = bar(rewarded_portion(3:4));
b.FaceColor = 'flat';
b.CData = color_data;
ylim([0 1])
ylabel('Proportion of rewarded trials')
set(gca, 'XTickLabel', [])
set(gca, 'YTick', y_labels, 'YTickLabel', y_labels)
title('Upper Left Target')

subplot(2, 2, 2)
b = bar(rewarded_portion(7:8));
b.FaceColor = 'flat';
b.CData = color_data;
ylim([0 1])
set(gca, 'XTickLabel', [])
set(gca, 'YTick', y_labels, 'YTickLabel', y_labels)
title('Upper Right Target')

subplot(2, 2, 3)
b = bar(rewarded_portion(1:2));
b.FaceColor = 'flat';
b.CData = color_data;
ylim([0 1])
set(gca, 'XTickLabel', [])
set(gca, 'YTick', y_labels, 'YTickLabel', y_labels)
title('Lower Left Target')

subplot(2, 2, 4)
b = bar(rewarded_portion(5:6));
b.FaceColor = 'flat';
b.CData = color_data;
ylim([0 1])
set(gca, 'XTickLabel', [])
set(gca, 'YTick', y_labels, 'YTickLabel', y_labels)
title('Lower Right Target')
