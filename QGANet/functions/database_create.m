% create database 

% directory setup
                 
data_dir = 'E:\QGANet\Data\BIDMC';                  % directory to save the sift features of the chosen dataset
% dataSet = 'Bone_retinex';
dataSet ='BIDMC';
rt_data_dir = fullfile(data_dir, dataSet);
subfolders = dir(rt_data_dir);

database.imnum = 0; % total image number of the database
database.cname = {}; % name of each class
database.label = []; % label of each class
database.path = {}; % contain the pathes for each image of each class
database.nclass = 0;

for ii = 1:length(subfolders),
    subname = subfolders(ii).name;
    
    if ~strcmp(subname, '.') & ~strcmp(subname, '..'),
        database.nclass = database.nclass + 1;
        
        database.cname{database.nclass} = subname;
        
        frames = dir(fullfile(rt_data_dir, subname, '*.mat'));
        
        c_num = length(frames);           
        database.imnum = database.imnum + c_num;
        database.label = [database.label; ones(c_num, 1)*database.nclass];
        
%         siftpath = fullfile(rt_data_dir, subname);        
%         if ~isdir(siftpath),
%             mkdir(siftpath);
%         end;
        
        for jj = 1:c_num,
            imgpath = fullfile(rt_data_dir, subname, frames(jj).name);
          
            

            database.path = [database.path, imgpath];
        end;    
    end;
end;