load('points.mat','x','y');
figure;hold on;
plot(x,y,'kx');
axis equal

%% RANSAC
% Arguments
p = 0.99; % probability of success
N = log(1-p)/log(1-(1-exp(1))^length(x)); % number of iterations
t = 0.95; % threshold
n = 2; % number of points to fit the model
Np = length(x); % number of points

for i = 1:N
    % randomly select n points
    idx = randperm(Np,n);
    x1 = x(idx(1));
    x2 = x(idx(2));
    y1 = y(idx(1));
    y2 = y(idx(2));
    
    % fit the model
    a = (y2-y1)/(x2-x1);
    b = y1 - a*x1;
    
    %% TODO: from here down
    
    % find the inliers
    d = abs(a*x-y+b)/sqrt(a^2+1);
    inliers = find(d<t);
    
    % check if the model is better
    if length(inliers) > length(bestInliers)
        bestInliers = inliers;
        bestModel = [a,b];
    end
end
