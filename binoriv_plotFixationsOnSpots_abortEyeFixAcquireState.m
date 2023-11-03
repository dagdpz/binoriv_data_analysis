function binoriv_plotFixationsOnSpots_abortEyeFixAcquireState(filename)

% load eye-tracker data file
load(filename, 'trial')

% filenames = {'Y:\Data\Linus\20220204\Lin2022-02-04_11.mat', ...
%     'Y:\Data\Linus\20220208\Lin2022-02-08_02.mat', ...
%     'Y:\Data\Linus\20220223\Lin2022-02-23_04.mat', ...
%     'Y:\Data\Linus\20220224\Lin2022-02-24_02.mat', ...
%     'Y:\Data\Linus\20220225\Lin2022-02-25_02.mat', ...
%     'Y:\Data\Linus\20220225\Lin2022-02-25_04.mat'};

figure,

fix_radius = trial(1).eye.fix.radius;
fix_size = trial(1).eye.fix.size;

% extract fix spot positions and color
trial_info = [];

for ii = 1:length(trial)
    trial_info(ii, :) = [trial(ii).eye.fix.pos(1:2) trial(ii).eye.fix.color_dim];
end

unqConditions = unique(trial_info, 'rows');

rewarded_trial_ids = [trial.rewarded] == 1;
abort_eye_fix_acq_state = cellfun(@(x) strcmp(x, 'ABORT_EYE_FIX_ACQ_STATE'), {trial.abort_code}, 'Uniformoutput', 1);

trial = trial(abort_eye_fix_acq_state);
trial_info = trial_info(abort_eye_fix_acq_state, :);

for trNum = 1:length(trial)
    
    hold_state_ids = ...
        trial(trNum).tSample_from_time_start > trial(trNum).states_onset(trial(trNum).states == 2) & ...
        trial(trNum).tSample_from_time_start < trial(trNum).states_onset(trial(trNum).states == 19);
    
    scatter(trial(trNum).x_eye(hold_state_ids), trial(trNum).y_eye(hold_state_ids), 1, ...
        trial_info(trNum, 3:5)/max(trial_info(trNum, 3:5)), ...
        'Marker', '.')
    hold on
    
end

axis square

xlim([-7 7])
ylim([-7 7])

% plot circles around the fix spots
fix_pos = unqConditions(1:end, 1:2);

for ii = 1:size(fix_pos, 1)
    
    circle(fix_pos(ii, 1), fix_pos(ii, 2), fix_radius);
    circle(fix_pos(ii, 1), fix_pos(ii, 2), fix_size/2);
    
end

scatter([-2.5 -2.5 2.5 2.5], [-2.5 2.5 -2.5 2.5], 40, 'k', 'Marker', '*')

label_numbers = -7:7;
set(gca, 'XTick', label_numbers, 'YTick', label_numbers)
set(gca, 'XTickLabel', label_numbers, 'YTickLabel', label_numbers)

xlabel('Visual angle, degrees')
ylabel('Visual angle, degrees')
box on
grid on

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, 'k:', 'LineWidth', 3);
hold off


