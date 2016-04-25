function [OutImg OutImgIdx] = QGA_output(InImg, InImgIdx, PatchSize, NumFilters, V)
% Computing PCA filter outputs
% ======== INPUT ============
% InImg         Input images (cell structure); each cell can be either a matrix (Gray) or a 3D tensor (RGB)   
% InImgIdx      Image index for InImg (column vector)
% PatchSize     Patch size (or filter size); the patch is set to be sqaure
% NumFilters    Number of filters at the stage right before the output layer 
% V             PCA filter banks (cell structure); V{i} for filter bank in the ith stage  
% ======== OUTPUT ===========
% OutImg           filter output (cell structure)
% OutImgIdx        Image index for OutImg (column vector)
% ========= CITATION ============
% T.-H. Chan, K. Jia, S. Gao, J. Lu, Z. Zeng, and Y. Ma, 
% "PCANet: A simple deep learning baseline for image classification?" submitted to IEEE TPAMI. 
% ArXiv eprint: http://arxiv.org/abs/1404.3606 

% Tsung-Han Chan [thchan@ieee.org]
% Please email me if you find bugs, or have suggestions or questions!

% addpath('./Utils')

ImgZ = length(InImg);
mag = (PatchSize-1)/2;
OutImg = cell(NumFilters*ImgZ,1); 
cnt = 0;
for i = 1:ImgZ
    [ImgX, ImgY, NumChls] = size(InImg{i});
    img = zeros(ImgX+PatchSize-1,ImgY+PatchSize-1, NumChls);
    img((mag+1):end-mag,(mag+1):end-mag,:) = InImg{i};    
    for k = 1:size(img,3)
    im(:,:,k) = im2col_general(img(:,:,k),[PatchSize PatchSize]); % collect all the patches of the ith image in a matrix
    end
    im = bsxfun(@minus, im, mean(im)); % patch-mean removal 
    clear img
    for j = 1:NumFilters  % 8
        cnt = cnt + 1;
        VV= permute(V(:,j,:),[2 1 3]);
        % Ê±¼ä»»¿Õ¼ä
        RR = [];
        for L = 1:130
                  % mm = im(:,:,:);% 1301044
        rr = qmatrix_mul(VV,im(:,(L-1)*10000+1:L*10000,:));
        RR = [RR,rr];
        end
        rr = qmatrix_mul(VV,im(:,1300001:end,:));
        RR = [RR,rr];
        OutImg{cnt} = reshape(RR,ImgX,ImgY,NumChls);  % convolution output
    end
    InImg{i} = [];
end
OutImgIdx = kron(InImgIdx,ones(NumFilters,1)); 