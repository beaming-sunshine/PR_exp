% ��ȡͼƬ������������mat�ļ�/�Ѵ�����ֱ�Ӷ�ȡ
if  exist('exp4.mat','file')==2
    load('exp4.mat')
    disp('��ȡmat�ļ��ɹ�!')
else  
    disp('��ȡmatʧ�ܣ���ʼ��ȡͼ��!')
    file_path3 =  'data\3\';% ͼ���ļ���·�� 
    file_path5 =  'data\5\';
    total=500;
    train=400;    %ѵ����
    xtrains=[];   
    xtests=[];
    ytrains=[];   
    ytests=[];
    %��ȡͼ��  ��ȡ����
    for i=1:1:total
        im = imread([file_path3 ,num2str(i,'%d'),'.jpg']);    %��ȡͼƬ
        hog = hog_feature_vector (im);          %��ȡ����
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


