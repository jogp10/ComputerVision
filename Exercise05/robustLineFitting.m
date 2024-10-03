load('points.mat','x','y');
figure;hold on;
plot(x,y,'kx');
axis equal

%% RANSAC
% Arguments
p = 0.99; % probability of success
e = 0.5; % probability that a point is an outlier
s = 2; % number of points to fit the model
std_x = std(x); 
std_y = std(y);
t = sqrt(3.84) * sqrt(std_x^2 + std_y^2); % threshold
Np = length(x); % number of points
N = log(1-p)/log(1-(1-e)^s); % number of iterations

bestModel = [];
bestInliers = [];

for i = 1:N
    % randomly select s points
    idx = randperm(Np,s);
    x1 = x(idx(1));
    x2 = x(idx(2));
    y1 = y(idx(1));
    y2 = y(idx(2));
    
    % fit the model
    slope = (y2-y1)/(x2-x1);
    intercept = y1 - slope * x1;
    
    % Find inliers by calculating the distance from the line
    d = abs(slope * x - y + intercept) / sqrt(slope^2 + 1);
    inliers = find(d < t);
    
    % check if the model is better
    if length(inliers) > length(bestInliers)
        bestInliers = inliers;
        bestModel = [slope, intercept];
    end
end

% Re-fit using total least squares on inliers
U = [(x(bestInliers) - mean(x(bestInliers)))', (y(bestInliers) - mean(y(bestInliers)))'];
[~, ~, V] = svd(U'*U); % Singular value decomposition

% The eigenvector corresponding to the smallest eigenvalue
a = V(1,end); 
b = V(2,end); 

d = (a * sum(x(bestInliers)) + b * sum(y(bestInliers))) / length(bestInliers);

% Plot the points and the estimated line
figure;
plot(x, y, 'ro'); 

hold on;
xFit = linspace(min(x), max(x), 100);
yFit = -(a/b) * xFit + d/b;
plot(xFit, yFit, 'b-', 'LineWidth', 2);


legend('Data points', 'Estimated line', 'Inliers');
xlabel('x'); ylabel('y');
title('RANSAC Fitting');

hold off;

% Print the estimated line
disp(['Estimated line: y = ' num2str(-a/b) 'x + ' num2str(d/b)]);
disp(['a = ' num2str(a) ', b = ' num2str(b), ', d = ' num2str(d)]);