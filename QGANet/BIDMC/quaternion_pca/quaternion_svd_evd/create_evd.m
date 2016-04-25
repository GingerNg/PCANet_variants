% N is the number of samples taken for each source 
% M is the number of sources
% Each source is a vector on the column of the matrix

clear all;
addpath('../quaternion_functions');
% read in the image
I = double(imresize(imread('mandrill512.tif'), [65 65]));

% create the quaternion representation of the image
[N M D] = size(I);

% compute each entry of matrix P based on S and V
Q = cat(3, zeros(N,M), I);

% calculate the average(quaternion) of each column vector
Mean = mean(Q,1);

% translate the column vector to the orgin so the mean is 0
Q = Q - repmat([Mean], [N 1]);   %Subtract the mean

% calculate the covariance matrix
A = qmatrix_mul(Q, qhermitian_trans(Q));
A = A/M;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do the quaternion eigenvalue decomposition on the covariance matrix A
[Vq, Dq] = qevd(A);


clear A D M N I;
save qevd Vq Mean Q Dq;