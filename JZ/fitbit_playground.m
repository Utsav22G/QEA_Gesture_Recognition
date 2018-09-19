clear all
close all
load accel_3d.mat
load gyro_3d.mat


t = Accelerometer(:, 1);
x = Accelerometer(:, 2); 
y = Accelerometer(:, 3); 
z = Accelerometer(:, 4);

grav1 = [x(1); y(1); z(1)]
a = linsolve([0.01;0.01;norm(grav1)], grav1)
b = (grav1)/[0.01;0.01;norm(grav1)]
start_pos = [0,0,0];

samp = 50;

x_filt = low_pass_filter(samp, x);
y_filt = low_pass_filter(samp, y);
z_filt = low_pass_filter(samp, z);

figure
hold on
plot(t, x);
plot(t, y);
plot(t, z);
legend('x', 'y', 'z');

figure
hold on
plot(t(samp:end), x_filt);
plot(t(samp:end), y_filt);
plot(t(samp:end), z_filt);
legend('x filt', 'y filt', 'z filt');

N = length(x_filt);
Fs = round(sum(diff(t)) / length(t));
freq_shifted = Fs * (linspace(-pi / 2, pi / 2, N) + pi/N*mod(N,2)) / (2 * pi);

x_filt_freq = fftshift(fft(x_filt));
y_filt_freq = fftshift(fft(y_filt));
z_filt_freq = fftshift(fft(z_filt));
% figure
% plot(freq_shifted, fftshift(abs(fft(x_filt))));
% figure
% plot(freq_shifted, fftshift(abs(fft(y_filt))));
% figure
% plot(freq_shifted, fftshift(abs(fft(z_filt))));

ind = find(abs(freq_shifted) > 0.1);
x_filt_freq(ind) = x_filt_freq(ind) * 0.1;
y_filt_freq(ind) = y_filt_freq(ind) * 0.1;
z_filt_freq(ind) = z_filt_freq(ind) * 0.1;

final_x = ifft(ifftshift(x_filt_freq));
final_y = ifft(ifftshift(y_filt_freq));
final_z = ifft(ifftshift(z_filt_freq));

figure
hold on
plot(t(samp:end), final_x);
plot(t(samp:end), final_y);
plot(t(samp:end), final_z);
legend('x filt', 'y filt', 'z filt');


figure
positions = [diff(diff(x_filt)), diff(diff(y_filt)), diff(diff(z_filt))];
x_pos = repmat(final_x,1,length(final_x));
x_pos_new = tril(x_pos);
x_pos_total = x_pos_new * ones(size(final_x));

y_pos = repmat(final_y,1,length(final_y));
y_pos_new = tril(y_pos);
y_pos_total = y_pos_new * ones(size(final_y));

z_pos = repmat(final_z,1,length(final_z));
z_pos_new = tril(z_pos);
z_pos_total = z_pos_new * ones(size(final_z));

scatter3(x_pos_total, y_pos_total, z_pos_total)


%%
function low_pass = low_pass_filter(samp, data)
    low_pass = data;
    for k = [samp:length(data)]
        res = (1/sum(1:samp))*(1:samp)*data(k-samp+1:k);
%         res = (1/12)*(data(k) + 5*data(k-1) + 4*data(k-2) + 3*data(k-3) + 2*data(k-4) + data(k-5));
        low_pass(k) = res;
    end
    low_pass = low_pass(samp:length(low_pass));
end