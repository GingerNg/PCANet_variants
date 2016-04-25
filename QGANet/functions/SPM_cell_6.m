%%%%%%%%%% SPM + SVM %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% parameter setting
% directory setup
% data_dir = 'F:\Shu\Data';                  % directory to save the sift features of the chosen dataset
% %dataSet = 'TRAIN_TEST_DATA_PCA';
% dataSet = 'Caltech101';
% % dataSet = 'Bone_retinex';
load('E:\PCANet\Data\Caltech101\Caltech101\0004_1.mat');
% load('F:\Shu\Data\feaSetXY');
% load('F:\Shu\Data\database');

% feature pooling parameters
pyramid = [1, 2, 4];                % spatial block number on each level of the pyramid
gamma = 0.15;
knn = 200;                          % find the k-nearest neighbors for approximate sparse coding
                                    % if set 0, use the standard sparse coding
% setting for SVM
% load('F:\Shu\Data\a2');
% num = 66;
% tr_num = 46;
                                    
% feaX = 3072;
% feaY = 3072;                                  
feaX = feaSet.x;
feaY = feaSet.y;

%% calculate the SPM feature

dimFea = sum(2048*pyramid.^2);%%
numFea = length(database.path);% 图片总数

PCA_fea = zeros(dimFea, numFea);
PCA_label = zeros(numFea, 1);%元素为0的列向量

disp('==================================================');
% fprintf('Calculating the sparse coding feature...\n');
% fprintf('Regularization parameter: %f\n', gamma);
disp('==================================================');

for iter1 = 1:numFea,  
    if ~mod(iter1, 50),
        fprintf('.\n');
    else
        fprintf('.');
    end;
    fpath = database.path{iter1};
    load(fpath);% 载入一张图片的feaSet
    feaSet.x = feaX;
    feaSet.y = feaY;
%     feaSet.feaArr = cr_codes;

% patch PCANet feature multi_channel
%      feaSet.feaArr = feaSet.feaArr(1:256,:);
%      feaSet.feaArr = feaSet.feaArr(257:512,:);
%      feaSet.feaArr = feaSet.feaArr(513:768,:);
%      feaSet.feaArr = feaSet.feaArr(769:1024,:);
%      feaSet.feaArr = feaSet.feaArr(1025:1280,:);
%      feaSet.feaArr = feaSet.feaArr(1281:1536,:);
%      feaSet.feaArr = feaSet.feaArr(1537:1792,:);
%      feaSet.feaArr = feaSet.feaArr(1793:2048,:);
    
   % if knn,
        PCA_fea(:, iter1) = approx_pooling_6(feaSet,pyramid, gamma, knn);
   % else
        %sc_fea(:, iter1) = sc_pooling(feaSet, B, pyramid, gamma);  % 10753*66
   % end
    PCA_label(iter1) = database.label(iter1);
end;

%-t kernel_type : set type of kernel function (default 2)
%	0 -- linear: u'*v
%	1 -- polynomial: (gamma*u'*v + coef0)^degree
%	2 -- radial basis function: exp(-gamma*|u-v|^2)   RBF
%	3 -- sigmoid: tanh(gamma*u'*v + coef0)
%	4 -- precomputed kernel (kernel values in training_set_file)

% %% SVM classifier
% 
% train_label = PCA_label(a(1:tr_num));
% train = PCA_fea(:,a(1:tr_num))';
% test_label = PCA_label(a(tr_num+1:end));
% test =  PCA_fea(:,a(tr_num+1:end))';
% 
% %% PCANet parameters
% model = svmtrain(train_label,train,'-t 0 -s 1 -q');
% 
% % [predict_label,accuracy] = svmpredict(test_label,test,model);
% [C1, acc , dec_values] = svmpredict(test_label,test,model);
% 
% % SVM assembly
% %-t kernel_type : set type of kernel function (default 2)
% %	0 -- linear: u'*v
% %	1 -- polynomial: (gamma*u'*v + coef0)^degree
% %	2 -- radial basis function: exp(-gamma*|u-v|^2)   RBF
% %	3 -- sigmoid: tanh(gamma*u'*v + coef0)
% %	4 -- precomputed kernel (kernel values in training_set_file)    
    


