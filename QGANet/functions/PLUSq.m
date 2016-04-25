%%PLUSq
function product = PLUSq(a,b)
for i = 1:size(a,3)
    product(:,:,i) = a(:,:,i)*b(:,:,i)';
end