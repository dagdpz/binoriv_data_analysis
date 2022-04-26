%clear all, close all

% load eye-tracker data file
% load(filename, 'trial')
load('Y:\Data\Linus\20220322\Lin2022-03-22_04.mat')

% extract fix spot positions and color
trial_info = [];
for ii = 1:length(trial)
    trial_info(ii, :) = [trial(ii).eye.fix.pos(1:2) trial(ii).eye.fix.color_dim];
    trial_pos(ii, :) = trial(ii).eye.fix.pos(1:2);
end

unqConditions = unique(trial_info, 'rows');
unqPositions = unique(trial_pos, 'rows');

% get trial IDs when fixation wasn't acquired
abort_eye_fix_acq_state = cellfun(@(x) strcmp(x, 'ABORT_EYE_FIX_ACQ_STATE'), {trial.abort_code}, 'Uniformoutput', 1);

% get trial IDs when fixation was broken
abort_eye_fix_hold_state = cellfun(@(x) strcmp(x, 'ABORT_EYE_FIX_HOLD_STATE'), {trial.abort_code}, 'Uniformoutput', 1);

% choose trials when fixation wasn't acquired
not_acquired_fixations = trial(abort_eye_fix_acq_state);



for currCondition = 1:size(unqConditions, 1)
    
    cellfun(@ (x) eq(x, unqPositions(1)), trial_info)
    eq()
    
end
    