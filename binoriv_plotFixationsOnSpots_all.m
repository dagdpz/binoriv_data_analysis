function binoriv_plotFixationsOnSpots_all(filename, only_correct)
% This function plots fixations and fixation radia in specified type of
% trials of the binoriv task.
%
% Input:
% + filename - the full path to the needed recording file
% + only_correct - if zero, plots all the trials irrespective to the
% outcome, otherwise plots only correct trials
%
% Example use:
% binoriv_plotFixationsOnSpots_all('Y:\Data\Linus\20220301\Lin2022-03-01_02.mat',
% 1) - this command plots correct trials for the specified session of Linus
%

% load eye-tracker data file
load(filename, 'trial', 'task')

% check the binoriv task data type (fixation or saccade)
if strcmp(task.custom_conditions, ...
        'D:\Sources\MATLAB\monkeypsych_3.0\conditions\Linus\combined_condition_file_Linus_binoriv_direct_saccade_grating')
    
    fieldname = 'tar';
    statenum = 5;
    
    time_hold = 'fix_time_hold';
    time_hold_var = 'fix_time_hold_var';
    
elseif strcmp(task.custom_conditions, ...
        'D:\Sources\MATLAB\monkeypsych_3.0\conditions\Linus\combined_condition_file_Linus_binoriv_fixation_grating')
    
    fieldname = 'fix';
    statenum = 3;
    
    time_hold = 'tar_time_hold';
    time_hold_var = 'tar_time_hold_var';
    
elseif strcmp(task.custom_conditions, ...
        'D:\Sources\MATLAB\monkeypsych_3.0\conditions\Linus\combined_condition_file_Linus')
    
    fieldname = 'fix';
    statenum = 3;
    
    time_hold = 'tar_time_hold';
    time_hold_var = 'tar_time_hold_var';
    
else
    error('Wrong Paradigm, Change Result File')
end

fix_radius = trial(end).eye.(fieldname).radius;
fix_size = trial(end).eye.(fieldname).size;

% extract fix spot positions and color
trial_info = [];
for ii = 1:length(trial)
    trial_info(ii, :) = [trial(ii).eye.(fieldname).pos(1:2) trial(ii).eye.(fieldname).color_dim];
end

unqConditions = unique(trial_info, 'rows');

rewarded_trial_ids = [trial.rewarded] == 1;
not_rewarded_trial_ids = [trial.rewarded] ~= 1;

% choose rewarded trials
rewarded_trials = trial(rewarded_trial_ids);
rewarded_trial_info = trial_info(rewarded_trial_ids, :);

if only_correct == 0
    % choose non-rewarded trials
    not_rewarded_trials = trial(not_rewarded_trial_ids);
    not_rewarded_trial_info = trial_info(not_rewarded_trial_ids, :);
end

figure('Position',[300 300 600 600]);

scatter(unqConditions(:, 1), unqConditions(:, 2), 500, 'k', 'Marker', '.')
hold on

for trNum = 1:length(rewarded_trials)
    
    hold_state_ids = ...
        rewarded_trials(trNum).tSample_from_time_start > rewarded_trials(trNum).states_onset(rewarded_trials(trNum).states == statenum) & ...
        rewarded_trials(trNum).tSample_from_time_start < rewarded_trials(trNum).states_onset(rewarded_trials(trNum).states == 20);
    
    col = rewarded_trial_info(trNum, 3:5)/max(rewarded_trial_info(trNum, 3:5));
    
%     s = scatter(rewarded_trials(trNum).x_eye(hold_state_ids), rewarded_trials(trNum).y_eye(hold_state_ids), 5, ...
%         col, 'Marker', 'o','MarkerFaceColor',col, 'MarkerEdgeColor',col, 'MarkerFaceAlpha',0.01,'MarkerEdgeAlpha',0);
    
    % plot mean
     s = scatter(mean(rewarded_trials(trNum).x_eye(hold_state_ids)), mean(rewarded_trials(trNum).y_eye(hold_state_ids)), 30, ...
         col, 'Marker', 'o','MarkerFaceColor',col, 'MarkerEdgeColor',col, 'MarkerFaceAlpha',0.25,'MarkerEdgeAlpha',0);
    
end

if only_correct == 0
    
    for trNum = 1:length(not_rewarded_trials)
        
        hold_state_ids = ...
            not_rewarded_trials(trNum).tSample_from_time_start > not_rewarded_trials(trNum).states_onset(not_rewarded_trials(trNum).states == statenum) & ...
            not_rewarded_trials(trNum).tSample_from_time_start < not_rewarded_trials(trNum).states_onset(not_rewarded_trials(trNum).states == 19);
        
        col = not_rewarded_trial_info(trNum, 3:5)/max(not_rewarded_trial_info(trNum, 3:5)) + 0.7;
        col(col == max(col)) = 1;
        
        scatter(not_rewarded_trials(trNum).x_eye(hold_state_ids), not_rewarded_trials(trNum).y_eye(hold_state_ids), 1, ...
            col, 'Marker', '.')
        
    end
    
end

axis square

xlim([-7 7])
ylim([-7 7])

% plot circles around the fix spots
fix_pos = unqConditions(1:end, 1:2);

for ii = 1:size(fix_pos, 1)
    
    circle(fix_pos(ii, 1), fix_pos(ii, 2), fix_radius);
    % circle(fix_pos(ii, 1), fix_pos(ii, 2), fix_size/2);
    
end

label_numbers = -7:7;
set(gca, 'XTick', label_numbers, 'YTick', label_numbers)
set(gca, 'XTickLabel', label_numbers, 'YTickLabel', label_numbers)

if only_correct == 0
    
    title([num2str(length(rewarded_trials)) ' correct trials, ' ...
        num2str(length(not_rewarded_trials)) ' incorrect trials'])
    
else
    
    title([num2str(length(rewarded_trials)) ' correct trials'],'FontSize',16)
    
end

xlabel('Visual angle, degrees','FontSize',16)
ylabel('Visual angle, degrees','FontSize',16)
box on
grid on
hold off

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, 'k:', 'LineWidth', 1);
hold off
