% 读取图片，将特征存入mat文件/已存在则直接读取
if  exist('exp2.mat','file')==2
    load('exp2.mat')
    disp('读取mat文件成功!')
else  
    disp('读取mat失败，开始读取图像!')
    file_path3 =  'data\3\';% 图像文件夹路径 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %训练集
    test=401;     %测试集
    trains=[];   
    tests=[];
    T=[];T2=[];
    %读取图像  提取特征
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %读取图片
        hog = hog_feature_vector (im);          %提取特征
        if i <= train
            trains=cat(1,trains,hog); 
            T = cat(1,T,-1);
            T2 =cat(1,T2,0);
        else
            tests=cat(1,tests,hog);
        end
    end
    for i=1:1:total
        im = imread([file_path5,num2str(i,'%d'),'.jpg']);
        hog = hog_feature_vector (im);
        if i <= train
            trains=cat(1,trains,hog); 
            T = cat(1,T,1);
            T2 =cat(1,T2,1);
        else
            tests=cat(1,tests,hog); 
        end
    end
    save('exp2.mat')
end

%最小二乘法
W = inv(trains'*trains)*trains'*T;
Y = W'*tests';
n=0;
for i=1:1:200
    if((i<101 && Y(:,i)<0)||(i>100 && Y(:,i)>0))
        n=n+1;
    end
end
disp(['最小二乘法的准确率为',num2str(n/2,'%.2f'),'%']);

%逻辑回归
lr = 0.001;
W= rand(144,1);
for i=1:1:110
    a = W'*trains';
    y =1./(1+exp(-a));
    dw = - ((T2'-y)*trains);
    W = W - lr*dw';
end
a = W'*tests';
Y =1./(1+exp(-a));
n=0;
for i=1:1:200
    if((i<101 && Y(:,i)<0.5)||(i>100 && Y(:,i)>0.5))
        n=n+1;
    end
end
disp(['逻辑回归(100轮学习率0.001)的准确率为',num2str(n/2,'%.2f'),'%']);