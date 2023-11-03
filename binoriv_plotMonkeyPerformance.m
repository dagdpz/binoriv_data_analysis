function binoriv_plotMonkeyPerformance(datafile)
% This code smoothes the monkey performance over all the trial outcomes 
% (rewarded, initiated and skipped)data with 'lowess' method and % plots 
% it.
%
% Example use:
% binoriv_plotMonkeyPerformance('Y:\Data\Linus\20220413\Lin2022-04-13_03.mat')
%

load(datafile, 'trial')

rewarded_trial_ids = [trial.rewarded] == 1;

y = smooth(rewarded_trial_ids, 30, 'lowess');

figure, plot(y)
ylim([0 1])

lastSlash = find(datafile == '\', 1, 'last');
ttl = datafile(lastSlash+1:end-4);

title(ttl, 'interpreter', 'none')
xlabel('Trial Number')
ylabel('Performance')
