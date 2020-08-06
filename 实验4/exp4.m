% 读取图片，将特征存入mat文件/已存在则直接读取
if  exist('exp4.mat','file')==2
    load('exp4.mat')
    disp('读取mat文件成功!')
else  
    disp('读取mat失败，开始读取图像!')
    file_path3 =  'data\3\';% 图像文件夹路径 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %训练集
    xtrains=[];   
    xtests=[];
    ytrains=[];   
    ytests=[];
    %读取图像  提取特征
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %读取图片
        hog = hog_feature_vector (im);          %提取特征
        if i <= train
            xtrains=cat(1,xtrains,hog);
            ytrains=cat(1,ytrains,-1);
        else
            xtests=cat(1,xtests,hog);
            ytests=cat(1,ytests,-1);
        end
    end
    for i=1:1:total
        im = imread([file_path5,num2str(i,'%d'),'.jpg']);
        hog = hog_feature_vector (im);
        if i <= train
            xtrains=cat(1,xtrains,hog); 
             ytrains=cat(1,ytrains,1);
        else
            xtests=cat(1,xtests,hog); 
            ytests=cat(1,ytests,1);
        end
    end
    save('exp4.mat')
end


