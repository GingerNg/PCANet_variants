function [beta] = approx_pooling(feaSet, pyramid, gamma, knn)
feaSet.feaArr = feaSet.feaArr2;
%================================================
% 
% Usage:
% Compute the linear spatial pyramid feature using sparse coding. 
%
% Inputss:
%   feaSet        -structure defining the feature set of an image   
%                       .feaArr     local feature array extracted from the
%                                   image, column-wise
%                       .x          x locations of each local feature, 2nd
%                                   dimension of the matrix
%                       .y          y locations of each local feature, 1st
%                               dimension of the matrix
%                       .width      width of the image
%                       .height     height of the image
%   B             -sparse dictionary, column-wise
%   pyramid       -defines structure of pyramid 
%   gamma         -sparsity regularization parameter
%   knn           -k nearest neighbors selected for sparse coding
% 
% Output:
%   beta          -multiscale max pooling feature
%
% Written by Jianchao Yang @ NEC Research Lab America (Cupertino)
% Mentor: Kai Yu
% July 2008
%
% Revised May. 2010
%===============================================

dSize = size(feaSet.feaArr,1); % 4096
% dSize = size(B, 2);  %  列数：1024
nSmp = size(feaSet.feaArr, 2); % 2961
img_width = 1024;%feaSet.width;
img_height = 768;%feaSet.height;
% img_width = 400;%feaSet.width;
% img_height = 400;%feaSet.height;
idxBin = zeros(nSmp, 1);

sc_codes = [feaSet.feaArr];
% sc_codes = zeros(dSize, nSmp);

% compute the local feature for each local feature
% D = feaSet.feaArr'*B;
% IDX = zeros(nSmp, knn);
% for ii = 1:nSmp,
% 	d = D(ii, :);
% 	[dummy, idx] = sort(d, 'descend');
% 	IDX(ii, :) = idx(1:knn);
% end
% 
% for ii = 1:nSmp,
%     y = feaSet.feaArr(:, ii);
%     idx = IDX(ii, :);
%     BB = B(:, idx);
%     sc_codes(idx, ii) = feature_sign(BB, y, 2*gamma);
% end

sc_codes = abs(sc_codes);

% spatial levels
pLevels = length(pyramid);
% spatial bins on each level
pBins = pyramid.^2;  % 1，4，16
% total spatial bins
tBins = sum(pBins); % 21

beta = zeros(dSize, tBins);
bId = 0;

for iter1 = 1:pLevels,  % 1，2，3   pyramid level
    
    nBins = pBins(iter1);% 1 4 16
    
    wUnit = img_width / pyramid(iter1); % every pyramid level size图块Bin的尺寸
    hUnit = img_height / pyramid(iter1);
    
    % find to which spatial bin each local descriptor belongs
    % ceil 是向离它最近的大整数取整
    xBin = ceil(feaSet.x / wUnit);% [feaSet.x feaSet.y]为feaArr的坐标;[xBin,yBin] 为在图块上的坐标
    yBin = ceil(feaSet.y / hUnit);
    idxBin = (yBin - 1)*pyramid(iter1) + xBin;% 1-3072
    
    for iter2 = 1:nBins,     
        bId = bId + 1;
        sidxBin = find(idxBin == iter2);  %  pyramid first level all patches max pooling
        if isempty(sidxBin),
            continue;
        end      
        beta(:, bId) = max(sc_codes(:, sidxBin), [], 2);% 取最大值
    end
end

if bId ~= tBins,
    error('Index number error!');
end

beta = beta(:);
beta = beta./sqrt(sum(beta.^2));
