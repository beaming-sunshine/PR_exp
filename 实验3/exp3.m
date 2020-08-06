% 读取图片，将特征存入mat文件/已存在则直接读取
if  exist('exp3.mat','file')==2
    load('exp3.mat')
    disp('读取mat文件成功!')
else  
    disp('读取mat失败，开始读取图像!')
    file_path3 =  'data\3\';% 图像文件夹路径 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %训练集
    trains=[];   
    tests=[];
    %读取图像  提取特征
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %读取图片
        hog = hog_feature_vector (im);          %提取特征
        if i <= train
            trains=cat(1,trains,hog); 
        else
            tests=cat(1,tests,hog);
        end
    end
    for i=1:1:total
        im = imread([file_path5,num2str(i,'%d'),'.jpg']);
        hog = hog_feature_vector (im);
        if i <= train
            trains=cat(1,trains,hog); 
        else
            tests=cat(1,tests,hog); 
        end
    end
    save('exp3.mat')
end

%类均值向量
m1 = mean(trains(1:400,:));
m2 = mean(trains(401:800,:));
%类内离散度
s1=zeros(144);s2=zeros(144);
for i=1:1:400
    s1=s1+(trains(i,:)-m1)'*(trains(i,:)-m1);
end
for i=401:1:800
    s2=s2+(trains(i,:)-m2)'*(trains(i,:)-m2);
end
sw=s1+s2;
%权重w
W=inv(sw)*(m1-m2)';
%阈值w0
W0=-0.5*(W'*m1'+W'*m2');

n=0;
Y=W'*tests'+W0;
for i=1:1:200
    if((i<101 && Y(:,i)>0)||(i>100 && Y(:,i)<0))
        n=n+1;
    end
end
disp(['Fisher判别的准确率为',num2str(n/2,'%.2f'),'%']);


