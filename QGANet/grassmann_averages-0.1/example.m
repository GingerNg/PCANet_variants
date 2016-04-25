% example
  D = 2; % we consider a two-dimensional problem
  N = 100; % we will generate 100 observations

  %% Generate a random Covariance matrix
  tmp = randn(D);
  Sigma = tmp.' * tmp;

  %% Sample from the corresponding Gaussian
  X = mvnrnd(zeros(D, 1), Sigma, N);

  %% Estimate the leading component
 % comp = grassmann_average(X, 1); % the second input is the number of component to estimate
comp = trimmed_grassmann_average(X, 8);
%   %% Plot the results
%   plot(X(:, 1), X(:, 2), 'ko', 'markerfacecolor', [255,153,51]./255);
%   axis equal
%   hold on
%   plot(3*[-comp(1), comp(1)], 3*[-comp(2), comp(2)], 'k', 'linewidth', 2)
%   hold off
%   axis off