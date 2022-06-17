function plotTrialTypes(filename)
% This function calculates the number of each trial type for the saccade 
% paradigm in Linus and plots his performance in each one (also works for 
% Magnus' saccade task).
%
% Example use:
% plotTrialTypes('Y:\Data\Linus\20220503\Lin2022-05-03_03.mat')
%

load(filename)

noAcqFix = 0;
abortFix = 0;
noAcqTar = 0;
abortTar = 0;
rewTrial = 0;

for trialNum = 1:length(trial)

    if length(trial(trialNum).states) == 3 & eq(trial(trialNum).states, [1 2 19])
        noAcqFix = noAcqFix + 1;
    elseif length(trial(trialNum).states) == 4 & eq(trial(trialNum).states, [1 2 3 19])
        abortFix = abortFix + 1;
    elseif length(trial(trialNum).states) == 5 & eq(trial(trialNum).states, [1 2 3 4 19])
        noAcqTar = noAcqTar + 1;
    elseif length(trial(trialNum).states) == 6 & eq(trial(trialNum).states, [1 2 3 4 5 19])
        abortTar = abortTar + 1;
    elseif length(trial(trialNum).states) == 7 & eq(trial(trialNum).states, [1 2 3 4 5 20 21]) % = correct
        rewTrial = rewTrial + 1;
    else
        disp('Unknown type of trial')
    end

end

figure,
bar([noAcqFix abortFix noAcqTar abortTar rewTrial]/length(trial))
set(gca, 'XTickLabel', ...
    {'noAcqFix', 'abortFix', 'noAcqTar', 'abortTar', 'rewTrial'})
xlabel('Trial type')
ylabel('% of trials')
ylim([0 1])

title(filename(end-19:end-4), 'interpreter', 'none')
