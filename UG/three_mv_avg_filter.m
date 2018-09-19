function filtered = three_mv_avg_filter(fft_data)
%   This function applies a three-point moving 
%   average filter to the input data
%   N = num of points for the filter
%   NOTE: Data must be in Fourier Basis

ith = numel(fft_data);
filtered = zeros(ith, 1);

filtered(1) = (1/3) * (fft_data(1) + fft_data(2));

for n = 2:ith-1
    filtered(n) = (1/3) *  (fft_data(n+1) + fft_data(n) + fft_data(n-1));
end

filtered(ith) = (1/3) * (fft_data(ith) + fft_data(ith-1));
end