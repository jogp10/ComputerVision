%% Do the tasks according to the instructions, see also comments in the code
% 

%% Test images are loaded
% Note: Must be double precision in the interval [0,1].
im = double(rgb2gray(imread('department2.jpg')))/255;

%% Addition of noise 
% "salt and pepper" noise
imns = imnoise(im,'salt & pepper',0.1);
% add zero-mean Gaussian noise
imng = im+0.05*randn(size(im));
imng(imng<0) = 0; imng(imng>1) = 1;

%% Gaussian filter of size 11x11 and std 2.5 
sigmad=2.5;

kernel_size = 11;
x = -floor(kernel_size/2):floor(kernel_size/2);
gaussian_1d = exp(-(x.*x)/(2*sigmad*sigmad));
gaussian_1d = gaussian_1d / sum(gaussian_1d); % Normalize the kernel

h = fspecial('gaussian', [11 11],2.5);
%% Instead of directly filtering with h, make a separable implementation
% where you use horizontal and vertical 1D convolutions
% gflt_imns=imfilter(imns,h);
% gflt_imng=imfilter(imng,h);

% % For imns image
gflt_imns_h = conv2(imns, gaussian_1d, 'same');  % horizontal convolution
gflt_imns = conv2(gflt_imns_h, gaussian_1d', 'same');  % vertical convolution

% % For imng image
gflt_imng_h = conv2(imng, gaussian_1d, 'same');  % horizontal convolution
gflt_imng = conv2(gflt_imng_h, gaussian_1d', 'same');  % vertical convolution

% That is, replace the above two lines, you can use conv2 and 
% one dimensional Gaussian filter kernel with the same standard deviation.
% The result should not change.

%% Apply median filtering, use neighborhood size 5x5
medflt_imns=medfilt2(imns, [5 5]);%%Replace with median filtered version of 'imns'
medflt_imng=medfilt2(imng, [5 5]);%%Replace with median filtered version of 'imng'
% That is, replace the above two lines, you can use matlab built-in function medfilt2

%% Bilateral filter parameters are defined below.
w     = 5;       % bilateral filter half-width, filter size = 2*w+1 = 11
sigma = [2.5 0.1]; % bilateral filter standard deviations

%% Apply bilateral filter to each image.
% bflt_imns=zeros(size(im));%%Replace with bilateral filtered version of 'imns'
% bflt_imng=zeros(size(im));%%Replace with bilateral filtered version of 'imng'
bflt_imns = bilateralfilter(imns,w,sigma);
bflt_imng = bilateralfilter(imng,w,sigma);
% That is, you need to implement bilateralfilter.m and use it above
% Use formulas (3.34)-(3.37) from Szeliski's book 
% with values sigma_d=sigma(1), sigma_r=sigma(2)

%% Display grayscale input image and filtered output.
figure(1); clf;
set(gcf,'Name','Filtering Results');

subplot(2,4,1); imagesc(imns);
axis image; colormap gray;
title('Input Image');

subplot(2,4,2); imagesc(gflt_imns);
axis image; colormap gray;
title('Result of Gaussian Filtering');

subplot(2,4,3); imagesc(medflt_imns);
axis image; colormap gray;
title('Result of Median Filtering');

subplot(2,4,4); imagesc(bflt_imns);
axis image; colormap gray;
title('Result of Bilateral Filtering');

subplot(2,4,5); imagesc(imng);
axis image; colormap gray;
title('Input Image');

subplot(2,4,6); imagesc(gflt_imng);
axis image; colormap gray;
title('Result of Gaussian Filtering');

subplot(2,4,7); imagesc(medflt_imng);
axis image; colormap gray;
title('Result of Median Filtering');

subplot(2,4,8); imagesc(bflt_imng);
axis image; colormap gray;
title('Result of Bilateral Filtering');
