function [output] = bilateralfilter(inputImage, w, sigma)
%BILATERALFILTER Summary of this function goes here
%   Detailed explanation goes here

    sigma_d=sigma(1);
    sigma_r=sigma(2);

    [rows, cols] = size(inputImage);
    output = zeros(size(inputImage));

    % Loop through each pixel in the image
    for i = 1:rows
        for j = 1:cols
            
            % Initialize the accumulators for the output pixel
            numerator = 0;
            denominator = 0;
            
            % Loop through the neighborhood of the pixel
            for k = max(1, i-w):min(rows, i+w)
                for l = max(1, j-w):min(cols, j+w)
                                        
                    % Get the spatial weight from the precomputed domain kernel
                    d_numerator = (i - k)^2 + (j - l)^2;
                    d = exp(-d_numerator / (2 * sigma_d^2));
                    
                    % Compute the range kernel (intensity difference)
                    intensityDiff = (inputImage(i, j) - inputImage(k, l))^2;
                    r = exp(-intensityDiff / (2 * sigma_r^2));
                    
                    % Compute the bilateral weight
                    w_ij = d * r;
                    
                    % Accumulate the weighted sum for the numerator and denominator
                    numerator = numerator + w_ij * inputImage(k, l);
                    denominator = denominator + w_ij;
                end
            end
            
            % Compute the output pixel value
            output(i, j) = numerator / denominator;
        end
    end
end
