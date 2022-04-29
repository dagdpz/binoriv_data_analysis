clear all, close all
% This script computes psychometric functions for red and blue color
% detection in Linus

% Data for blue fixations spots shown through the red filter (into the 
% right eye)
% 'Y:\Data\Linus\20220331\Lin2022-03-31_07.mat'

% Data for blue fixations spots shown through the red filter (into the 
% right eye)
% 'Y:\Data\Linus\20220331\Lin2022-03-31_09.mat'

load('Y:\Data\Linus\20220331\Lin2022-03-31_09.mat')

trial_num = length(trial);

% extract fix spot positions and color
trial_info = [];

for ii = 1:length(trial)
    color_info(ii, :) = trial(ii).eye.fix.color_dim;
end

color_cell = mat2cell(color_info, ones(trial_num, 1), 3);

unqConditions = unique(color_info, 'rows');

rewarded_trial_ids = [trial.rewarded] == 1;

for colorNum = 1:size(unqConditions, 1)
    
    currColorId = cellfun(@(x) isequal(x, unqConditions(colorNum, :)), color_cell, 'UniformOutput', 1);
    
    currColorRewarded = currColorId & rewarded_trial_ids';
    
    color_performance(colorNum) = sum(currColorRewarded) / sum(currColorId);
    
end

color_intensity = unqConditions;
color_intensity(color_intensity == 0) = [];

figure,
plot(color_intensity, color_performance)
ylim([0 1])
xlabel('Color Intensity')
ylabel('Performance')
