function plotSingleDayResults(filename)
% This function plots training results for a specified day and file of
% Linus' training.
%
% Input:
% + filename - the full path to the data file
%
%
% Example use:
% plotSingleDayResults(filename)
%

close all

trainDate = filename(24:end-4);

savename = ['Y:\Projects\BinoRiv\Linus_training\' filename(24:end-4) '.ppt'];

ppt = saveppt2(savename, 'init');

% create blank title page
saveppt2('ppt', ppt, 'f', 0, 't', trainDate, 'driver', 'meta');

% plot fixations in correct trials
plotFixationsOnSpots_all(filename, 1)

% add the created plot to the ppt
saveppt2('ppt', ppt, 'f', 1, 'driver', 'meta')

% close the figure
close(1)


% plot fixations in all trials
plotFixationsOnSpots_all(filename, 0)

% add the created plot to the ppt
saveppt2('ppt', ppt, 'f', 1, 'driver', 'meta')

% close the figure
close(1)


% plot performance over trial types
calculateCorrectTrials(filename)

% add the created plot to the ppt
saveppt2('ppt', ppt, 'f', 1, 'driver', 'meta')

% close the figure
close(1)


% close the ppt when finished
saveppt2(savename, 'ppt', ppt, 'close');

end