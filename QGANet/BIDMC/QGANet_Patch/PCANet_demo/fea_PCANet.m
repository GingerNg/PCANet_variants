% PCANet for feature extractor
% input:2fold 58*2 images
% out: feature:2048*9801
clear all;

PCANet.NumStages = 2;
PCANet.PatchSize = 7;
PCANet.NumFilters = [8 8];
PCANet.HistBlockSize = [7 7]; 
PCANet.BlkOverLapRatio = 0.5;

fprintf('\n ====== PCANet Parameters ======= \n')
PCANet
% paramerters setting
Ntrain = 58; % 取58幅图训练;
nTestImg = 58;
% a由该“a=randperm(195426);”语句生成;
load('C:\Shu\data\a1');

data_dir = 'C:\Shu\image\TCB_Challenge_Data';
dataSet = 'TRAIN_TEST_DATA';
rt_data_dir = fullfile(data_dir, dataSet);% data\Caltch101
subfolders = dir(rt_data_dir);% 低 中 高;

sift_all = cell(116,1);
train = cell(58,1);
feaPCA = cell(116,1);

            
for ii = 1:length(subfolders),
    subname = subfolders(ii).name; % 文件夹的名称：低分化新，中分化新，高分化新；
    
    if ~strcmp(subname, '.') && ~strcmp(subname, '..'),
%         database.nclass = database.nclass + 1;
        
%         database.cname{database.nclass} = subname;
        
        frames = dir(fullfile(rt_data_dir, subname, '*.tif'));% .mat 文件的路径;
        
        c_num = length(frames); % 文件夹里.mat文件的数目;  
        
    
%         if ~isdir(feapath),
%             mkdir(feapath);% 创建文件夹 subname文件夹
%         end;
        
        for jj = 1:c_num,   % c_num*length(subfolders)= 图片总数;
            imgpath = fullfile(rt_data_dir, subname, frames(jj).name);% frames（jj）.name的路径
            
            I = imread(imgpath);
            sift_all{((ii-3)*58+jj),1} =double(I);
            
         
        end;    
    end;
end;

% 从特征文件中抽取训练样本；一张图片里面有RGB三层；
% 取训练样本 ;
TrnData_ImgCell = {sift_all{a(1:Ntrain),:}}';
TestData_ImgCell = {sift_all{a(Ntrain+1:end),:}}';
fprintf('\n ====== PCANet Training ======= \n')
[ftrain V BlkIdx] = feaPCANet_train(TrnData_ImgCell,PCANet,1); 
fprintf('\n ====== PCANet Testing ======= \n')
for idx = 1:1:116
    
    feaPCA{idx,1} = feaPCANet_FeaExt(sift_all(idx),V,PCANet); % extract a test feature using trained PCANet model 

    
end




    