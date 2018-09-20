close all
clear all
load 

horiz_thresh = round(length(norm_acc) / 10);
vert_thresh = mean(norm_acc(2:end)) + 1.25 * std(norm_acc(2:end));
[highs, high_ind] = findpeaks(norm_acc, 'MinPeakProminence', vert_thresh, 'MinPeakDistance', horiz_thresh);
[lows, low_ind] = findpeaks(-norm_acc, 'MinPeakProminence', vert_thresh, 'MinPeakDistance', horiz_thresh);


figure 
hold on
plot(norm_acc)
plot(high_ind, highs, 'rs')
plot(low_ind, -lows, 'rs')
%% Functions
