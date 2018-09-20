close all
clear all
load normal_acc.mat

norm_acc = ans;
[peaks, ind] = findpeaks(norm_acc, 'MinPeakProminence', 

%% Functions
