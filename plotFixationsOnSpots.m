function plotFixationsOnSpots(filename)
% This function plots 


% load eye-tracker data file
load(filename, 'trial')

% filenames = {'Y:\Data\Linus\20220204\Lin2022-02-04_11.mat', ...
%     'Y:\Data\Linus\20220208\Lin2022-02-08_02.mat', ...
%     'Y:\Data\Linus\20220223\Lin2022-02-23_04.mat', ...
%     'Y:\Data\Linus\20220224\Lin2022-02-24_02.mat', ...
%     'Y:\Data\Linus\20220225\Lin2022-02-25_02.mat', ...
%     'Y:\Data\Linus\20220225\Lin2022-02-25_04.mat', ...
%     'Y:\Data\Linus\20220303\Lin2022-03-03_04.mat'};

fix_radius = trial(1).eye.fix.radius;

% extract fix spot positions and color
trial_info = [];
for ii = 1:length(trial)
    trial_info(ii, :) = [trial(ii).eye.fix.pos(1:2) trial(ii).eye.fix.color_dim];
end

unqConditions = unique(trial_info, 'rows');

rewarded_trial_ids = [trial.rewarded] == 1;

trial = trial(rewarded_trial_ids);
trial_info = trial_info(rewarded_trial_ids, :);

figure,

for trNum = 1:length(trial)
    
    hold_state_ids = ...
        trial(trNum).tSample_from_time_start > trial(trNum).states_onset(trial(trNum).states == 3)+0.5 & ...
        trial(trNum).tSample_from_time_start < trial(trNum).states_onset(trial(trNum).states == 20)-0.5;
    
    scatter(trial(trNum).x_eye(hold_state_ids), trial(trNum).y_eye(hold_state_ids), 1, ...
        trial_info(trNum, 3:5)/max(trial_info(trNum, 3:5)), ...
        'Marker', '.')
    hold on
    
end

axis square

xlim([-7 7])
ylim([-7 7])

scatter(unqConditions(:, 1), unqConditions(:, 2), 40, 'k', 'Marker', '*')

viscircles(unqConditions(1:2:end, 1:2), repmat(fix_radius, [1 4]), 'Color', 'k', 'LineStyle', '--')

label_numbers = -7:7;
set(gca, 'XTick', label_numbers, 'YTick', label_numbers)
set(gca, 'XTickLabel', label_numbers, 'YTickLabel', label_numbers)

xlabel('Visual angle, degrees')
ylabel('Visual angle, degrees')
box on
grid on