%%quaternion convolution
function result = qua_cov(V,im)
Vq = qua2com2(V);
imq = qua2com2(im);
test = Vq'*imq;
result = com2qua2(test(:,1:size(test,2)/2,:));