function output = reconstLaplacianPyramid(lapPyramid)
    % RECONSTLAPLACIANPYRAMID Reconstructs the image from its Laplacian pyramid.
    % lapPyramid: Cell array of Laplacian pyramid images (from finest to coarsest).
    % output: Reconstructed image.

    % Binomial kernel for filtering (low-pass)
    g = [1 4 6 4 1] / 16;
    kernel = g' * g;  % 2D binomial kernel

    % Start with the smallest image (base of the pyramid)
    levels = length(lapPyramid);
    currentImage = lapPyramid{levels};  % Base image (smallest resolution)

    for i = levels-1:-1:1
        currentImage = upsampleAndFilter(currentImage, kernel * 2);

        % Ensure the upsampled image matches the size of the current Laplacian level
        [rows, cols, ~] = size(lapPyramid{i});
        currentImage = imresize(currentImage, [rows, cols]);

        % Add the Laplacian image at this level
        currentImage = currentImage + lapPyramid{i};
    end

    % The final result is the reconstructed image
    output = currentImage;
end

function upsampledImage = upsampleAndFilter(image, kernel)
    % UPSAMPLEANDFILTER performs upsampling and filtering
    % Upsample by adding zeros between rows and columns
    upsampledImage = upsample(image, 2);

    % Apply the low-pass filter after upsampling
    upsampledImage = imfilter(upsampledImage, kernel, 'replicate');
end
