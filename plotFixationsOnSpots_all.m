function plotFixationsOnSpots_all(filename)
% This function plots fixations in correct trials of binoriv task
% 
% Example use:
% plotFixationsOnSpots('Y:\Data\Linus\20220301\Lin2022-03-01_02.mat')
% 

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
not_rewarded_trial_ids = [trial.rewarded] ~= 1;

% choose rewarded trials
rewarded_trials = trial(rewarded_trial_ids);
rewarded_trial_info = trial_info(rewarded_trial_ids, :);

% choose non-rewarded trials
not_rewarded_trials = trial(not_rewarded_trial_ids);
not_rewarded_trial_info = trial_info(not_rewarded_trial_ids, :);

figure,

for trNum = 1:length(rewarded_trials)
    
    hold_state_ids = ...
        rewarded_trials(trNum).tSample_from_time_start > rewarded_trials(trNum).states_onset(rewarded_trials(trNum).states == 3)+0.5 & ...
        rewarded_trials(trNum).tSample_from_time_start < rewarded_trials(trNum).states_onset(rewarded_trials(trNum).states == 20)-0.5;
    
    col = rewarded_trial_info(trNum, 3:5)/max(rewarded_trial_info(trNum, 3:5));
    
    scatter(rewarded_trials(trNum).x_eye(hold_state_ids), rewarded_trials(trNum).y_eye(hold_state_ids), 1, ...
        col, 'Marker', '.')
    hold on
    
end

for trNum = 1:length(not_rewarded_trials)
        
    hold_state_ids = ...
        not_rewarded_trials(trNum).tSample_from_time_start > not_rewarded_trials(trNum).states_onset(not_rewarded_trials(trNum).states == 3) & ...
        not_rewarded_trials(trNum).tSample_from_time_start < not_rewarded_trials(trNum).states_onset(not_rewarded_trials(trNum).states == 19);
    
    col = not_rewarded_trial_info(trNum, 3:5)/max(not_rewarded_trial_info(trNum, 3:5)) + 0.7;
    col(col == max(col)) = 1;
    
    scatter(not_rewarded_trials(trNum).x_eye(hold_state_ids), not_rewarded_trials(trNum).y_eye(hold_state_ids), 1, ...
        col, 'Marker', '.')
    hold on
    
end

axis square

xlim([-7 7])
ylim([-7 7])

scatter(unqConditions(:, 1), unqConditions(:, 2), 500, 'k', 'Marker', '.')
%viscircles(unqConditions(1:2:end, 1:2), repmat(fix_radius, [1 4]), 'Color', 'k', 'LineStyle', '--')

% plot circles around the fix spots
fix_pos = unqConditions(1:end, 1:2);

for ii = 1:size(fix_pos, 1)
    
    circle(fix_pos(ii, 1), fix_pos(ii, 2), fix_radius);
    
end

label_numbers = -7:7;
set(gca, 'XTick', label_numbers, 'YTick', label_numbers)
set(gca, 'XTickLabel', label_numbers, 'YTickLabel', label_numbers)

title([num2str(length(rewarded_trials)) ' correct trials, ' ...
    num2str(length(not_rewarded_trials)) ' incorrect trials'])

xlabel('Visual angle, degrees')
ylabel('Visual angle, degrees')
box on
grid on
hold off

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, 'k:', 'LineWidth', 1.5);
hold off
