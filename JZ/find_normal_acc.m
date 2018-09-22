function a_lat = find_normal_acc(dataset, samp, freq_cutoff, attenuation, plotting)
    load(dataset);
    rot_trans = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

    t = 0:(1/Fs):((length(Accel)-1)/Fs);
    t = t(samp:end);
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
    if plotting
        figure
        hold on
        plot(t, vx);
        plot(t, vy);
        title('velocity components vs. time')
        xlabel('time (s)')
        ylabel('velocity (m/s)');
        legend('x axis', 'y axis');
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

    if plotting
        figure
        grid on
        plot(t, a_lat);
        title("normal acceleration: " + dataset, 'Interpreter', 'None')
        grid on
    end

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