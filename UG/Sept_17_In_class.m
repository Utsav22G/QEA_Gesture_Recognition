clc; clear;

%%      Read the data

accel_file = 'Accelerometer.csv';
accel = csvread(accel_file, 1, 1);

gyro_file = 'Gyroscope.csv';
gyro = csvread(gyro_file, 1, 1);

%%      Plot the data against time

figure
hold on
plot(accel(:, 1), accel(:, 2))
plot(accel(:, 1), accel(:, 3))
plot(accel(:, 1), accel(:, 4))
xlabel('Time (in ms)')
ylabel('Accelerometer Reading (in ms^-2)')
legend('X-axis', 'Y-axis', 'Z-axis')
title('Accelerometer-Time plot')
hold off

figure
hold on
plot(gyro(:, 1), gyro(:, 2))
plot(gyro(:, 1), gyro(:, 3))
plot(gyro(:, 1), gyro(:, 4))
xlabel('Time (in ms)')
ylabel('Gyroscope Reading (in ms^-2)')
legend('X-axis', 'Y-axis', 'Z-axis')
title('Gyro-Time plot')
hold off

%%      Plot frequency of data

ms_to_s = 1000;
N = numel(accel(:, 2)); Fs = 100;
freq = linspace(-Fs/2, Fs*(1- 1/N)/2, N);

%   freq in mHz, multiply by ms_to_s for Hz
fft_X = fftshift(fft(accel(:, 2)));
fft_Y = fftshift(fft(accel(:, 3)));
fft_Z = fftshift(fft(accel(:, 4)));

figure
subplot(3,1,1)
plot(freq, abs(fft_X))
xlabel('Frequency (in mHz)')
ylabel('X-axis accelaration')

subplot(3,1,2)
plot(freq, abs(fft_Y))
xlabel('Frequency (in mHz)')
ylabel('Y-axis accelaration')

subplot(3,1,3)
plot(freq, abs(fft_Y))
xlabel('Frequency (in mHz)')
ylabel('Z-axis accelaration')

X_filt = three_mv_avg_filter(fft_X);
Y_filt = three_mv_avg_filter(fft_Y);
Z_filt = three_mv_avg_filter(fft_Z);

figure
subplot(3,1,1)
plot(freq, abs(X_filt))
xlabel('Frequency (in mHz)')
ylabel('X-axis accelaration')

subplot(3,1,2)
plot(freq, abs(Y_filt))
xlabel('Frequency (in mHz)')
ylabel('Y-axis accelaration')

subplot(3,1,3)
plot(freq, abs(Z_filt))
xlabel('Frequency (in mHz)')
ylabel('Z-axis accelaration')

figure
subplot(2,1,1)
hold on
plot(freq, fft_X)
plot(freq, fft_Y)
plot(freq, fft_Z)
hold off
xlabel('Frequencies (in mHz)')
ylabel('Amplitude')
title('Original Frequencies')
legend('X-axis', 'Y-axis', 'Z-axis')

subplot(2,1,2)
hold on
plot(freq, X_filt)
plot(freq, Y_filt)
plot(freq, Z_filt)
hold off
xlabel('Frequencies (in mHz)')
ylabel('Amplitude')
title('Filtered Frequencies')
legend('X-axis', 'Y-axis', 'Z-axis')



























