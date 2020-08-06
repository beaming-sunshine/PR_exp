% ��ȡͼƬ������������mat�ļ�/�Ѵ�����ֱ�Ӷ�ȡ
if  exist('exp2.mat','file')==2
    load('exp2.mat')
    disp('��ȡmat�ļ��ɹ�!')
else  
    disp('��ȡmatʧ�ܣ���ʼ��ȡͼ��!')
    file_path3 =  'data\3\';% ͼ���ļ���·�� 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %ѵ����
    test=401;     %���Լ�
    trains=[];   
    tests=[];
    T=[];T2=[];
    %��ȡͼ��  ��ȡ����
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %��ȡͼƬ
        hog = hog_feature_vector (im);          %��ȡ����
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

%��С���˷�
W = inv(trains'*trains)*trains'*T;
Y = W'*tests';
n=0;
for i=1:1:200
    if((i<101 && Y(:,i)<0)||(i>100 && Y(:,i)>0))
        n=n+1;
    end
end
disp(['��С���˷���׼ȷ��Ϊ',num2str(n/2,'%.2f'),'%']);

%�߼��ع�
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
disp(['�߼��ع�(100��ѧϰ��0.001)��׼ȷ��Ϊ',num2str(n/2,'%.2f'),'%']);