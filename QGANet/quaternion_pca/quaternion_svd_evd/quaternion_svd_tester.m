% let this be a test
% see if i can use this to edit
clear all;
close all;

% load the SVD of the image
load qsvd;


Vq = qhermitian_trans(Vq);

% set the rank number
k = 256;

Uk = Uq(:,1:k,:);
Vk = Vq(1:k,:,:);

Sk_matrix = zeros(k, k, 4);
Sk_matrix(:,:,1) = diag(Sq(1:k));


% truncate the singular values and basis vectors based on the ranking
P = qmatrix_mul(qmatrix_mul(Uk,Sk_matrix), Vk);
P = P +repmat([Mean], [size(P,1) 1]);
mi = min(min(min(P(:,:,2:4))));
ma = max(max(max(P(:,:,2:4))));

figure; imshow((P(:,:,2:4)-mi)/(ma-mi));
