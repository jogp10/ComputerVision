load('points.mat','x','y');
figure;hold on;
plot(x,y,'kx');
axis equal

%% RANSAC
% Arguments
p = 0.99; % probability of success
e = 0.5; % probability that a point is an outlier
s = 2; % number of points to fit the model
t = 0.10; % threshold
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
    line = slope*x+intercept;
    
    % Find inliers by calculating the distance from the line
    d = abs(slope * x - y + intercept) / sqrt(slope^2 + 1);
    inliers = find(d < t);
    
    % check if the model is better
    if length(inliers) > length(bestInliers)
        bestInliers = inliers;
        bestModel = [slope, intercept];
    end
end

x_inliers = x(bestInliers);
y_inliers = y(bestInliers);

x_plot = linspace(min(x), max(x), 100);
y_plot = bestModel(1) * x_plot + bestModel(2);

% Plot the original data points
figure;
scatter(x, y, 'b'); 
hold on;

% Plot the fitted line
plot(x_plot, y_plot, 'r', 'LineWidth', 2);

% Plot the inliers
scatter(x_inliers, y_inliers, 'g');

legend('Data Points', 'Fitted Line', 'Inliers');
xlabel('X');
ylabel('Y');
title('RANSAC Line Fitting');

% Display the equation of the best line on the plot
equationText = ['y = ', num2str(bestModel(1), '%.2f'), 'x + ', num2str(bestModel(2), '%.2f')];
x_pos = mean(x); % Position the text around the center of the x values
y_pos = mean(y) + 0.1; % Position the text slightly below the top of the y range
text(x_pos, y_pos, equationText, 'FontSize', 12, 'Color', 'k', 'BackgroundColor', 'w');

hold off;

% Report the best model
disp(['Best slope a = ', num2str(bestModel(1))]);
disp(['Best intercept b = ', num2str(bestModel(2))]);
disp(['Equation of best line: y = ', num2str(bestModel(1)), 'x + ', num2str(bestModel(2))]);
