%%Image2Qua
% create the quaternion representation of the image
function Q = Image2Qua(I)
[N M D] = size(I);
Q = cat(3, zeros(N,M), I); %cat：用来联结数组

% calculate the average(quaternion) of each column vector 列
Mean = mean(Q,1);

% translate the column vector to the orgin so the mean is 0
Q = Q - repmat([Mean], [N 1]);   %Subtract the mean