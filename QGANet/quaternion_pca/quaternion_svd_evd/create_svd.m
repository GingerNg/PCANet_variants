clear all;
addpath('../quaternion_functions');

% read in the image
I = double(imresize(imread('mandrill512.tif'), [256, 256]));

% create the quaternion representation of the image
[N M D] = size(I);
Q = cat(3, zeros(N,M), I); %cat：用来联结数组

% calculate the average(quaternion) of each column vector
Mean = mean(Q,1);

% translate the column vector to the orgin so the mean is 0
Q = Q - repmat([Mean], [N 1]);   %Subtract the mean


[Uq, Sq, Vq] = qsvd(Q);

% clear I D;
% save qsvd Uq Sq Vq N M Q Mean;

