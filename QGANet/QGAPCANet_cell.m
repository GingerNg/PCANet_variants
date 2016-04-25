%%%%%%%%%%%%%%%%%%%%%%%%%
% PCANet for Cell_He
% input images
% random 10000 patch to train filter
% output;feature&Filter&accuracy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% PCANet for feature extractor
% input:images
% out: V
% clear all;

tic;
%% parameter setting
PCANet.NumStages = 2;
PCANet.PatchSize = 16;
PCANet.NumFilters = [8 8];
PCANet.HistBlockSize = [16 16]; 
PCANet.BlkOverLapRatio = 0;

fprintf('\n ====== PCANet Parameters ======= \n')
PCANet


Img_dir = 'E:\QGANet\Image';
data_dir = 'E:\QGANet\Data\Caltech101';
dataSet = 'Caltech101';
% dataSet = 'Hematoxylin';
% dataSet = 'eosin';
% dataSet='TRAIN_TEST_Data';
%% 
skip_filter = false;
rt_data_dir = fullfile(data_dir, dataSet);% data\Caltch101
rt_Img_dir = fullfile(Img_dir, dataSet);
subfolders = dir(rt_Img_dir);% 低 中 高;
NumImg = 66;
sift_all = cell(NumImg,1);
% train = cell(Ntrain,1);
counter = 0; % 

if ~skip_filter
%% get the training sample           
for ii = 1:length(subfolders),
    subname = subfolders(ii).name; % 文件夹的名称：低分化新，中分化新，高分化新；
    
    if ~strcmp(subname, '.') && ~strcmp(subname, '..'),
        
        frames = dir(fullfile(rt_Img_dir, subname, '*.jpg'));% .mat 文件的路径;
        
        c_num = length(frames); % 文件夹里.mat文件的数目;  
        for jj = 1:c_num,   % c_num*length(subfolders)= 图片总数;
            imgpath = fullfile(rt_Img_dir, subname, frames(jj).name);% frames（jj）.name的路径
          I = Image2Qua(im2double(imread(imgpath)));% 彩色图像图像转换为四元数；   
            counter = counter+1;
            sift_all{counter,1} = I;
        end;   
     end;    
end;
TrnData_ImgCell = sift_all;

%% calculate QGANet Filter
fprintf('\n ====== PCANet Training ======= \n')
[ftrain V BlkIdx] = feaQGANet_train_cell(TrnData_ImgCell,PCANet,0); 
save('E:\QGANet\Data\Caltech101\V','V');
else
load('E:\QGANet\Data\Caltech101\V','V');
end
%% calculate the QGANet feature
for ii = 1:length(subfolders),
    subname = subfolders(ii).name; 
    
    if ~strcmp(subname, '.') && ~strcmp(subname, '..'),
        
        frames = dir(fullfile(rt_Img_dir, subname, '*.jpg'));% .mat 文件的路径;
        
        c_num = length(frames); % 文件夹里.mat文件的数目;  
        
        feapath = fullfile(rt_data_dir, subname);
        if ~isdir(feapath),
            mkdir(feapath);% 创建文件夹 subname文件夹
        end;
        
        for jj = 1:c_num,   % c_num*length(subfolders)= 图片总数;
            imgpath = fullfile(rt_Img_dir, subname, frames(jj).name);% frames（jj）.name的路径
             fprintf('Processing %s: \n', ...
                     frames(jj).name);
            I = im2double(imread(imgpath));
            I_cell ={Image2Qua(I)};  % convert RGB image to quaternion
            feaSet.feaArr = feaQGANet_FeaExt(I_cell,V,PCANet); % 特征提取
            
            [pdir, fname] = fileparts(frames(jj).name);                        
            fpath = fullfile(rt_data_dir, subname, [fname, '.mat']);
            
            save(fpath, 'feaSet');

        end;    
    end;
end;

%% SPM and SVM
database_create_cell;
SPM_cell;
SVM_Loo_cell;