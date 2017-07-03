function centroids = kMeansInitCentroids(X, k)
%KMEANSINITCENTROIDS Randomly selects k different data points from X to use as
% the initial centroids for k-Means clustering.
%   centroids = KMEANSINITCENTROIDS(X, k) returns k initial centroids to be
%   used with the k-Means on the dataset X
%
%   Parameters
%     X  - The dataset, one data point per row.
%     k  - The number of cluster centers.
%
%   Returns
%     A matrix of centroids with k rows.

%    Author: Yangyang Fu
%    Date: 07/03/2017

centroids = zeros(k, size(X, 2));

% Randomly reorder the indices of examples
randidx = randperm(size(X, 1));

% Take the first k examples as centroids
centroids = X(randidx(1:k), :);

end

