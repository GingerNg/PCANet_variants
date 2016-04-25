function im = im2col_general(varargin)
% 

NumInput = length(varargin);
InImg = varargin{1}; % T
patchsize12 = varargin{2}; 

z = size(InImg,3); % »Ò¶ÈÍ¼Ïñ£ºsize(InImg,3)·µ»Ø1
im = cell(z,1);
if NumInput == 2
    for i = 1:z
        %IM2COLSTEP Rearrange matrix blocks into columns.
        im{i} = im2colstep(InImg(:,:,i),patchsize12)';
    end
else
    for i = 1:z
        im{i} = im2colstep(InImg(:,:,i),patchsize12,varargin{3})';
    end 
end
im = [im{:}]';
    
    