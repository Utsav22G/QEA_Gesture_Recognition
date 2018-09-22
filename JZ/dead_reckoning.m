%dead reckon

file1 = "../2D_motion_data/TriangleNoTremors6Lin.mat";
dead_reckon(file1, 10, 1, 0.01, 0)

function pos = dead_reckon(dataset, samp, freq_cutoff, attenuation, plotting)
    load(dataset);
    rot_trans = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

    ta = 0:(1/Fs):((length(Accel)-1)/Fs);
    ta = ta(samp:end);
    
    tg = 0:(1/Fs):((length(Gyro)-1)/Fs);
    tg = tg(samp:end);
    
    ax = Accel(:, 1);
    ay = Accel(:, 2);
    az = Accel(:, 3);
    if plotting
       figure
       hold on
       plot(ax)
       plot(ay)
       plot(az)
    end
%     ax = ax - ones(size(Accel(:, 1))) * Accel(1, 1);
%     ay = ay - ones(size(Accel(:, 2))) * Accel(1, 2);
%     az = az - ones(size(Accel(:, 3))) * Accel(1, 3);
%     
    ax = low_pass_filter(samp, ax)'; 
    ay = low_pass_filter(samp, ay)'; 
    az = low_pass_filter(samp, az)';
    
    wx = low_pass_filter(samp, Gyro(:, 1));
    wy = low_pass_filter(samp, Gyro(:, 2));
    wz = low_pass_filter(samp, Gyro(:, 3));
    
    
    N = length(ax);
    freq_shifted = Fs * (linspace(-pi / 2, pi / 2, N) + pi/N*mod(N,2)) / (2 * pi);

    x_freq = fftshift(fft(ax));
    y_freq = fftshift(fft(ay));
    
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

    N = length(wz);
    freq_shifted = Fs * (linspace(-pi / 2, pi / 2, N) + pi/N*mod(N,2)) / (2 * pi);
    z_freq = fftshift(fft(wz));
    ind = find(abs(freq_shifted) > freq_cutoff);
    z_freq(ind) = z_freq(ind) * attenuation;
    
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
    wz = real(ifft(ifftshift(z_freq)));
end

