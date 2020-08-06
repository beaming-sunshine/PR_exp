% ��ȡͼƬ������������mat�ļ�/�Ѵ�����ֱ�Ӷ�ȡ
if  exist('exp3.mat','file')==2
    load('exp3.mat')
    disp('��ȡmat�ļ��ɹ�!')
else  
    disp('��ȡmatʧ�ܣ���ʼ��ȡͼ��!')
    file_path3 =  'data\3\';% ͼ���ļ���·�� 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %ѵ����
    trains=[];   
    tests=[];
    %��ȡͼ��  ��ȡ����
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %��ȡͼƬ
        hog = hog_feature_vector (im);          %��ȡ����
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

%���ֵ����
m1 = mean(trains(1:400,:));
m2 = mean(trains(401:800,:));
%������ɢ��
s1=zeros(144);s2=zeros(144);
for i=1:1:400
    s1=s1+(trains(i,:)-m1)'*(trains(i,:)-m1);
end
for i=401:1:800
    s2=s2+(trains(i,:)-m2)'*(trains(i,:)-m2);
end
sw=s1+s2;
%Ȩ��w
W=inv(sw)*(m1-m2)';
%��ֵw0
W0=-0.5*(W'*m1'+W'*m2');

n=0;
Y=W'*tests'+W0;
for i=1:1:200
    if((i<101 && Y(:,i)>0)||(i>100 && Y(:,i)<0))
        n=n+1;
    end
end
disp(['Fisher�б��׼ȷ��Ϊ',num2str(n/2,'%.2f'),'%']);


