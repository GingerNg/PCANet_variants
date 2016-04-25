clear all;
close all;

% load the SVD of the image
load qevd;

[N M D] = size(Q);

% set the rank number
k = 65;


% truncate the singular values and basis vectors based on the ranking
Vk = Vq(:,1:k,:);


% compute each entry of matrix P based on S and V
Y = qmatrix_mul(qhermitian_trans(Vk), Q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reconstruct the original image
P = qmatrix_mul(Vk, Y);

P = P + repmat([Mean], [N 1]);   % add back the mean
Q = Q + repmat([Mean], [N 1]);

ma = max(max(max(Y)));
mi = min(min(min(Y)));

figure; imshow((Y(:,:,2:4)-mi)/(ma-mi));
figure; imshow(uint8(P(:,:,2:4)));
figure; imshow(uint8(Q(:,:,2:4)));

