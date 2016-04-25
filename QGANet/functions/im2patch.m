function impatch = im2patch(img,grid,patchsize,sign)
[m,n,z]=size(img);% m = 768,n=1024
impatch=[];
if sign == 1
     for i = 1:grid:m-patchsize+1
         for j=1:grid:n-patchsize+1
               patch = img(i:i+patchsize-1,j:j+patchsize-1,:);
               for k = 1:size(patch,3)
               patch_col(:,:,k) = im2col_general(patch(:,:,k),[patchsize patchsize]);
               end
               impatch = [impatch,patch_col];
         end
    end
else
     for i = 1:grid:n-patchsize+1
         for j=1:grid:m-patchsize+1
               impatch = [impatch;img(i:i+patchsize-1,j:j+patchsize-1)];
         end
    end
end

