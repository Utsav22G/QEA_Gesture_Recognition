clear all
close all

% file1 = '../2D_motion_data/TriangleNoTremors1.mat';
% find_normal_acc(file1, 100, 0.1, 1);
% 
% file1 = "../2D_motion_data/TriangleWithTremors1.mat";
% find_normal_acc(file1, 10, 0.4, 0.001, 0);
% 
% file2 = "../2D_motion_data/TriangleWithTremors2.mat";
% find_normal_acc(file2, 10, 0.4, 0.001, 0);
% 
% file1 = "../2D_motion_data/TriangleNoTremors1.mat";
% find_normal_acc(file1, 10, 0.4, 0.001, 0);
% 
% file2 = "../2D_motion_data/TriangleNoTremors2.mat";
% find_normal_acc(file2, 10, 0.4, 0.001, 0);
% 
% file3 = "../2D_motion_data/CircleWithTremors1.mat";
% find_normal_acc(file3, 10, 0.4, 0.001, 0);
% 
% file3 = "../2D_motion_data/CircleWithTremors2.mat";
% find_normal_acc(file3, 10, 0.4, 0.001, 0);
% 
% file3 = "../2D_motion_data/CircleNoTremors1.mat";
% find_normal_acc(file3, 10, 0.4, 0.001, 0);
% 
% file3 = "../2D_motion_data/CircleNoTremors2.mat";
% find_normal_acc(file3, 10, 0.4, 0.001, 0);

file1 = "../2D_motion_data/SquareWithTremors1.mat";
find_normal_acc(file1, 10, 0.4, 0.001, 0);

file2 = "../2D_motion_data/SquareWithTremors2.mat";
find_normal_acc(file2, 10, 0.4, 0.001, 0);

file1 = "../2D_motion_data/SquareNoTremors1.mat";
find_normal_acc(file1, 10, 0.4, 0.01, 0);

file2 = "../2D_motion_data/SquareNoTremors2.mat";
find_normal_acc(file2, 10, 0.4, 0.01, 0);
%%
function a_lat = find_normal_acc(dataset, samp, freq_cutoff, attenuation, plotting)
    load(dataset);
    rot_trans = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

    samp = 100;
    t = 0:(1/Fs):((length(Accel)-1)/Fs);
    t = t(samp:end);
    ax = low_pass_filter(samp, Accel(1:end, 1))'; 
    ay = low_pass_filter(samp, Accel(1:end, 2))'; 
    az = low_pass_filter(samp, Accel(1:end, 3))';
%     
%     wx = low_pass_filter(samp, Gyro(:, 1))'; 
%     wy = low_pass_filter(samp, Gyro(:, 2))'; 
%     wz = low_pass_filter(samp, Gyro(:, 3))';
    
    N = length(ax);
    freq_shifted = Fs * (linspace(-pi / 2, pi / 2, N) + pi/N*mod(N,2)) / (2 * pi);

    x_freq = fftshift(fft(ax));
    y_freq = fftshift(fft(ay));
%     z_freq = fftshift(fft(wz));
%     
   if plotting
        figure
        subplot(2, 1, 1)
        plot(freq_shifted, abs(x_freq));
        title('unfiltered fft of x axis');
        subplot(2,1,2)
        plot(freq_shifted, abs(y_freq));
        title('unfiltered fft of y axis');
   end

    ind = find(abs(freq_shifted) > freq_cutoff);
    x_freq(ind) = x_freq(ind) * attenuation;
    y_freq(ind) = y_freq(ind) * attenuation;
%     z_freq(ind) = z_freq(ind) * attenuation;
    
    if plotting
        figure
        subplot(2, 1, 1)
        plot(freq_shifted, abs(x_freq));
        title('filtered fft of x axis');
        subplot(2,1,2)
        plot(freq_shifted, abs(y_freq));
        title('filtered fft of y axis');
    end
    
    ax = real(ifft(ifftshift(x_freq)));
    ay = real(ifft(ifftshift(y_freq)));
%     wz = abs(ifft(ifftshift(z_freq)));
    
%     heading = cumtrapz(t, wz);
    vx = cumtrapz(t, ax);
    vy = cumtrapz(t, ay);
    vz = cumtrapz(t, az);
    pos = zeros(2,length(vx));
    
%     for index = 1:length(heading)
%         pos(:, index) = (rot_trans(heading(index)) * [vx(index); vy(index)]*1/Fs);
%     end
%     x = cumtrapz(t, vx);
%     y = cumtrapz(t, vy);
%     


    figure
    hold on
    plot(t, vx);
    plot(t, vy);
    title('velocity components vs. time')
    xlabel('time (s)')
    ylabel('velocity (m/s)');
    legend('x axis', 'y axis');
    if plotting    
        figure
        hold on
        plot(t, ax);
        plot(t, ay);
        title('acceleration components vs. time')
        xlabel('time (s)')
        ylabel('acceleration (m/s^2)');
        legend('x axis', 'y axis');
    end

    a = [ax; ay];
    v = [vx; vy];
    t_hat = v ./ vecnorm(v);
    n_hat = rot_trans(pi/2) * t_hat;

    a_long = dot(a, t_hat);
    a_lat = dot(a, n_hat);

    figure
    plot(t, a_lat);
    title("normal acceleration: " + dataset, 'Interpreter', 'None')

end

function low_pass = low_pass_filter(samp, data)
    low_pass = data;
    for k = [samp:length(data)]
        res = (1/sum(1:samp))*(1:samp)*data(k-samp+1:k);
%         res = (1/12)*(data(k) + 5*data(k-1) + 4*data(k-2) + 3*data(k-3) + 2*data(k-4) + data(k-5));
        low_pass(k) = res;
    end
    low_pass = low_pass(samp:length(low_pass));
end