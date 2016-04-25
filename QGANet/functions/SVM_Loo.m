% leave one out ：
% 样本个数：for 的次数
% 每次一个样本测试，其他训

sc_fea = PCA_fea;
sc_label = PCA_label;
ptest_label = zeros(length(sc_label),1);

% %% binary class
% for KK=1:length(sc_label)
%     if sc_label(KK) ==2
%         sc_label(KK) =1;
%     end
%     if sc_label(KK) ==3
%         sc_label(KK) =2;
%     end
% end

[dimFea, numFea] = size(sc_fea);% 特征的维数，及样本的个数
clabel = unique(sc_label);

temp_acc =0;
% 
train_label = sc_label(2:end);
train = sc_fea(:,2:end)';
test_label = sc_label(1);
test =  sc_fea(:,1)';

%PCANet parameters
model = svmtrain(train_label,train,'-t 0 -s 1 -q');
[C1, acc , dec_values] = svmpredict(test_label,test,model);
temp_acc = temp_acc+acc(1);
ptest_label(1) = C1;
clear model
% PCA_acc = accuracy;


for i = 2:numFea

    
train_label = [sc_label(1:i-1);sc_label(i+1:end)];
train = [sc_fea(:,1:i-1),sc_fea(:,i+1:end)]';
test_label = sc_label(i);
test =  sc_fea(:,i)';

%PCANet parameters
model = svmtrain(train_label,train,'-t 0 -s 1 -q');
[C1, acc , dec_values] = svmpredict(test_label,test,model);
ptest_label(i) = C1;
clear model
temp_acc = temp_acc+acc(1);

end

Mean_Acc = temp_acc/numFea

testlabel = sc_label;
tp=zeros(3,1);
for i=1:3;%设标签1-5分别为阳性，其他为阴性
    ind_l=find(testlabel==i);tpfn(i)=length(ind_l);tnfp(i)=length(testlabel)-tpfn(i);
    ind_p=find(ptest_label==i);
    for a=1:length(ind_l);
        for b=1:length(ind_p);
            if ind_l(a)==ind_p(b);
                tp(i)=tp(i)+1;                    
           
           end
        end
    end
    %敏感度（真阳性率）=原本是阳性，判断为阳性/【（原本是阳，判断为阳）+（原本是阳，判断为阴）】
    %特异性（真阴性率）=原本是阴性，判断为阴性/【（原本是阴，判断为阴）+（原本是阴，判断为阳）】
sen(i)=tp(i)/tpfn(i);

end
tn=zeros(3,1);
for i=1:3;%设标签1-5分别为阳性，其他为阴性
    ind_l=find(testlabel~=i);tnfp2(i)=length(ind_l);
    ind_p=find(ptest_label~=i);
    for a=1:length(ind_l);
        for b=1:length(ind_p);
            if ind_l(a)==ind_p(b);
                tn(i)=tn(i)+1;                    
            end
        end
    end
spe(i)=tn(i)/tnfp2(i);
end   