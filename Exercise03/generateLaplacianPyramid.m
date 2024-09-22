function [output] = generateLaplacianPyramid(inputImage,pyramidType,levels)
%GENERATELAPLACIANPYRAMID Summary of this function goes here
%   Detailed explanation goes here
% Output is cell array (i.e. lpimga{i} is the Laplacian image at level i).
% The image at the final level is the base level image from the
% corresponding Gaussian pyramid.
% In the version the second input is either 'lap' or 'gauss',
% and it defines whether to output Laplacian or Gaussian pyramid.


    g = [1 4 6 4 1]/16; % binomial filter kernel
    kernel = g'*g; % 2D kernel

    gaussPyramid = cell(levels, 1);
    gaussPyramid{1} = inputImage;

    % Generate the Gaussian pyramid by downsampling the image
    for i = 2:levels
        % Apply low-pass filter (convolution)
        smoothedImage = imfilter(gaussPyramid{i-1}, kernel, 'replicate');
        % Downsample the image (reduce resolution by a factor of 2)
        gaussPyramid{i} = smoothedImage(1:2:end, 1:2:end, :);
    end

    if strcmp(pyramidType, 'gauss')
        output = gaussPyramid;
        return;
    end

    % Initialize Laplacian pyramid as a cell array
    lapPyramid = cell(levels, 1);

    % Generate the Laplacian pyramid
    for i = 1:levels-1
        % Upsample the next level in the Gaussian pyramid
        upsampledImage = upsampleAndFilter(gaussPyramid{i+1}, kernel * 2);
        % Adjust the size of the upsampled image to match the current level
        upsampledImage = imresize(upsampledImage, size(gaussPyramid{i}(:,:,1)));
        % Subtract the upsampled image from the current Gaussian level
        lapPyramid{i} = gaussPyramid{i} - upsampledImage;
    end

    % The final level of the Laplacian pyramid is the base Gaussian image
    lapPyramid{levels} = gaussPyramid{levels};
    
    output = lapPyramid;
end

function upsampledImage = upsampleAndFilter(image, kernel)
    % UPSAMPLEANDFILTER performs upsampling and filtering
    % Upsample by adding zeros between rows and columns
    upsampledImage = upsample(image, 2);

    % Apply the low-pass filter after upsampling
    upsampledImage = imfilter(upsampledImage, kernel, 'replicate'); % need to resize after using 'replicate'
end
