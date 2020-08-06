% ��ȡͼƬ������������mat�ļ�/�Ѵ�����ֱ�Ӷ�ȡ
if  exist('exp1.mat','file')==2
    load('exp1.mat')
    disp('��ȡmat�ļ��ɹ�!')
else  
    disp('��ȡmatʧ�ܣ���ʼ��ȡͼ��!')
    file_path3 =  'data\3\';% ͼ���ļ���·�� 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %ѵ����
    test=401;     %���Լ�
    hog3=[];    
    %��ȡͼ��  ��ȡ����
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %��ȡͼƬ
        hog = hog_feature_vector (im);          %��ȡ����
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


 %�����˹�����Ĳ�������ֵu������sigma
u0=mean(hog3(1:train,:));
u1=mean(hog5(1:train,:));
sigma0=[0];
sigma1=[0];
%����sigma
for i=1:1:train
   sigma0 =sigma0 + (hog3(i,:)-u0)'*(hog3(i,:)-u0);
   sigma1 =sigma1 + (hog5(i,:)-u1)'*(hog5(i,:)-u1);
end
sigma0=sigma0/train;
sigma1=sigma1/train;


%����ѵ����׼ȷ��
n0=0;n1=0;
for i=test:1:total
    hog = hog3(i,:);         %��ȡ���� 
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
disp(['ͨ����ѵ��',num2str(train,'%d'),'��ͼƬ����ȷ��Ϊ',num2str(acc,'%.3f'),'%'])


%�������һ��
disp("�������һ�ţ�5/488")
im = imread('data\5\488.jpg');
hog = hog_feature_vector (im);
N0=(1/((2*pi)^72))*(1/(norm(sigma0)^(1/2)))*exp((-1/2)*(hog-u0)*inv(sigma0)*(hog-u0)');
N1=(1/((2*pi)^72))*(1/(norm(sigma1)^(1/2)))*exp((-1/2)*(hog-u1)*inv(sigma1)*(hog-u1)');

disp(['N0=',num2str(N0),'   N1=',num2str(N1)])
if N0 > N1
    disp("��ʶ������3")
elseif N0 < N1
    disp("��ʶ������5")
end



