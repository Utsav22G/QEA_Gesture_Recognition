close all
clear all

file1 = "../2D_motion_data/TriangleNoTremors6Lin.mat";
peaks("TriangleNoTremors6Lin", find_normal_acc(file1, 10, 0.4, 0.001, 1));

file1 = "../2D_motion_data/TriangleWithTremors6Lin.mat";
peaks("TriangleWithTremors6Lin", find_normal_acc(file1, 10, 0.4, 0.001, 1));

file1 = "../2D_motion_data/CircleWithTremors6Lin.mat";
peaks("CircleWithTremors6Lin", find_normal_acc(file1, 10, 0.4, 0.001, 1));

file1 = "../2D_motion_data/CircleNoTremors6Lin.mat";
peaks("CircleNoTremors6Lin", find_normal_acc(file1, 10, 0.4, 0.001, 1));

% file2 = "../2D_motion_data/TriangleWithTremors2.mat";
% peaks("TriangleWithTremors2", find_normal_acc(file2, 10, 0.4, 0.001, 0));
% 
% file3 = "../2D_motion_data/TriangleWithTremors4.mat";
% peaks("TriangleWithTremors4", find_normal_acc(file3, 10, 0.4, 0.001, 0));
% 
% file4 = "../2D_motion_data/TriangleWithTremors1.mat";
% peaks("TriangleWithTremors1", find_normal_acc(file3, 10, 0.4, 0.001, 0));
% 
% file1 = "../2D_motion_data/CircleWithTremors1.mat";
% peaks("CirlceWithTremors1", find_normal_acc(file1, 10, 0.4, 0.001, 0));
% 
% file2 = "../2D_motion_data/CircleWithTremors2.mat";
% peaks("CirlceWithTremors2", find_normal_acc(file2, 10, 0.4, 0.001, 0));
% 
% file3 = "../2D_motion_data/CircleWithTremors3.mat";
% peaks("CirlceWithTremors3", find_normal_acc(file3, 10, 0.4, 0.001, 0));

% file1 = '../Normal_Acceleration_Data/CNT1.mat';
% file2 = '../Normal_Acceleration_Data/CNT2.mat';
% file3 = '../Normal_Acceleration_Data/CWT1.mat';
% file4 = '../Normal_Acceleration_Data/CWT2.mat';
% file5 = '../Normal_Acceleration_Data/TWT2.mat';
% file6 = '../Normal_Acceleration_Data/TWT4.mat';
% 
% 
% peaks(file1)
% peaks(file2)
% peaks(file3)
% peaks(file4)
% peaks(file5)
% peaks(file6)

%%
function res = peaks(plot_title, norm_acc)
    horiz_thresh = round(length(norm_acc) / 10);
    pos_vals = find(norm_acc > 0);
    neg_vals = find(norm_acc < 0);
    vert_thresh_pos = mean(norm_acc(pos_vals)) +  1.25 * std(norm_acc(pos_vals));
    vert_thresh_neg = mean(norm_acc(neg_vals)) -  1.25 * std(norm_acc(neg_vals));
    [highs, high_ind] = findpeaks(norm_acc, 'MinPeakProminence', vert_thresh_pos, 'MinPeakDistance', horiz_thresh);
    [lows, low_ind] = findpeaks(-norm_acc, 'MinPeakProminence', -vert_thresh_neg, 'MinPeakDistance', horiz_thresh);

    figure
    hold on

    peak_index= sort([high_ind, low_ind]);
    res = [peak_index(1)];
    
    for index = 2:length(peak_index)
       if (sign(norm_acc(res(end))) * sign(norm_acc(peak_index(index))) == -1)
           res = [res, peak_index(index)];
       end
    end
    title(plot_title, 'Interpreter', 'None')
    plot(norm_acc)
    plot(res, norm_acc(res), 'rs')
    grid on
end