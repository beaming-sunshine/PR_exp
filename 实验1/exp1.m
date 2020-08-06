% 读取图片，将特征存入mat文件/已存在则直接读取
if  exist('exp1.mat','file')==2
    load('exp1.mat')
    disp('读取mat文件成功!')
else  
    disp('读取mat失败，开始读取图像!')
    file_path3 =  'data\3\';% 图像文件夹路径 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %训练集
    test=401;     %测试集
    hog3=[];    
    %读取图像  提取特征
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %读取图片
        hog = hog_feature_vector (im);          %提取特征
        hog3=cat(1,hog3,hog);   
    end
    hog5=[];
    for i=1:1:total
        im = imread([file_path5,num2str(i,'%d'),'.jpg']);
        hog = hog_feature_vector (im);
        hog5= cat(1,hog5,hog);
    end
    save('exp1.mat')
end


 %计算高斯函数的参数：均值u、方差sigma
u0=mean(hog3(1:train,:));
u1=mean(hog5(1:train,:));
sigma0=[0];
sigma1=[0];
%计算sigma
for i=1:1:train
   sigma0 =sigma0 + (hog3(i,:)-u0)'*(hog3(i,:)-u0);
   sigma1 =sigma1 + (hog5(i,:)-u1)'*(hog5(i,:)-u1);
end
sigma0=sigma0/train;
sigma1=sigma1/train;


%测试训练的准确率
n0=0;n1=0;
for i=test:1:total
    hog = hog3(i,:);         %提取特征 
    %N=(1/((2*pi)^72))*(1/(norm(sigma)^0.5))*exp((-1/2)*(x-u)'*inv(sigma)*(x-u));
    N0=(1/((2*pi)^72))*(1/(norm(sigma0)^(1/2)))*exp((-1/2)*(hog-u0)*inv(sigma0)*(hog-u0)');
    N1=(1/((2*pi)^72))*(1/(norm(sigma1)^(1/2)))*exp((-1/2)*(hog-u1)*inv(sigma1)*(hog-u1)');
    if N0 > N1
        n0 = n0+1;
    end
end
for i=test:1:total
    hog = hog5(i,:);
    N0=(1/((2*pi)^72))*(1/(norm(sigma0)^(1/2)))*exp((-1/2)*(hog-u0)*inv(sigma0)*(hog-u0)');
    N1=(1/((2*pi)^72))*(1/(norm(sigma1)^(1/2)))*exp((-1/2)*(hog-u1)*inv(sigma1)*(hog-u1)');
    if N0 < N1
        n1 = n1+1;
    end
end
acc = (n0+n1)*100/200;
disp(['通过各训练',num2str(train,'%d'),'张图片的正确率为',num2str(acc,'%.3f'),'%'])


%随意测试一张
disp("随意测试一张：5/488")
im = imread('data\5\488.jpg');
hog = hog_feature_vector (im);
N0=(1/((2*pi)^72))*(1/(norm(sigma0)^(1/2)))*exp((-1/2)*(hog-u0)*inv(sigma0)*(hog-u0)');
N1=(1/((2*pi)^72))*(1/(norm(sigma1)^(1/2)))*exp((-1/2)*(hog-u1)*inv(sigma1)*(hog-u1)');

disp(['N0=',num2str(N0),'   N1=',num2str(N1)])
if N0 > N1
    disp("该识别结果是3")
elseif N0 < N1
    disp("该识别结果是5")
end



