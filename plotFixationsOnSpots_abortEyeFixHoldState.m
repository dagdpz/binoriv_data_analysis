clear all, close all

filenames = {'Y:\Data\Linus\20220204\Lin2022-02-04_11.mat', ...
    'Y:\Data\Linus\20220208\Lin2022-02-08_02.mat', ...
    'Y:\Data\Linus\20220223\Lin2022-02-23_04.mat', ...
    'Y:\Data\Linus\20220224\Lin2022-02-24_02.mat', ...
    'Y:\Data\Linus\20220225\Lin2022-02-25_02.mat', ...
    'Y:\Data\Linus\20220225\Lin2022-02-25_04.mat'};

fix_radius = [3 3 2.5 2.5 2.5 2.5];

for flNum = 6;%1:4
    
    % load eye-tracker data file
    load(filenames{flNum})
    
    % extract fix spot positions and color
    trial_info = [];
    for ii = 1:length(trial)
        trial_info(ii, :) = [trial(ii).eye.fix.pos(1:2) trial(ii).eye.fix.color_dim];
    end
    
    unqConditions = unique(trial_info, 'rows');
    
    rewarded_trial_ids = [trial.rewarded] == 1;
    abort_eye_fix_hold_state = cellfun(@(x) strcmp(x, 'ABORT_EYE_FIX_HOLD_STATE'), {trial.abort_code}, 'Uniformoutput', 1);
    
    trial = trial(abort_eye_fix_hold_state);
    trial_info = trial_info(abort_eye_fix_hold_state, :);
    
    figure,
    
    for trNum = 1:length(trial)
        
        hold_state_ids = ...
            trial(trNum).tSample_from_time_start > trial(trNum).states_onset(trial(trNum).states == 3) & ...
            trial(trNum).tSample_from_time_start < trial(trNum).states_onset(trial(trNum).states == 19);
        
        scatter(trial(trNum).x_eye(hold_state_ids), trial(trNum).y_eye(hold_state_ids), 1, ...
            trial_info(trNum, 3:5)/max(trial_info(trNum, 3:5)), ...
            'Marker', '.')
        hold on
        
    end
    
    axis square
    
    xlim([-7 7])
    ylim([-7 7])
    
    scatter([-2.5 -2.5 2.5 2.5], [-2.5 2.5 -2.5 2.5], 40, 'k', 'Marker', '*')
    
    viscircles(unqConditions(1:2:end, 1:2), repmat(fix_radius(flNum), [1 4]), 'Color', 'k', 'LineStyle','--')

    label_numbers = -7:7;
    set(gca, 'XTick', label_numbers, 'YTick', label_numbers)
    set(gca, 'XTickLabel', label_numbers, 'YTickLabel', label_numbers)
    
    xlabel('Visual angle, degrees')
    ylabel('Visual angle, degrees')
    box on
    grid on
end
