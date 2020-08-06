
clc
clear

addpath('..\utility')
posTrainData=zeros(40,144);
for i=1:40
    %读取一幅图片
    im = imread(['..\data\3\' num2str(i) '.jpg']);
    %提取hog特征，
    aFeat = hog_feature_vector(im);
    posTrainData(i,:) = aFeat;
end


negTrainData=zeros(40,144);
for i=1:40
    %读取一幅图片
    im = imread(['..\data\5\' num2str(i) '.jpg']);
    %提取hog特征，
    aFeat = hog_feature_vector(im);
    negTrainData(i,:) = aFeat;
end



testData=[];
for i=41:50
    %读取一幅图片
    im = imread(['..\data\3\' num2str(i) '.jpg']);
    %提取hog特征，
    aFeat = hog_feature_vector(im);
    testData = [testData; aFeat];
end

for i=41:50
    %读取一幅图片
    im = imread(['..\data\5\' num2str(i) '.jpg']);
    %提取hog特征，
    aFeat = hog_feature_vector(im);
    testData = [testData; aFeat];
end

% 已知的测试标签
testLabel = [ones(10,1);zeros(10,1)];


% miu sigma MLE
posMiu = mean(posTrainData);
posSigma=zeros(144,144);
for i=1:40
   tmpData = posTrainData(i,:);
   tmpSigma =  (tmpData-posMiu)'*(tmpData-posMiu);
   posSigma = posSigma+tmpSigma;
end
posSigma = posSigma/40;

negMiu = mean(negTrainData);
negSigma=zeros(144,144);
for i=1:40
   tmpData = negTrainData(i,:);
   tmpSigma =  (tmpData-negMiu)'*(tmpData-negMiu);
   negSigma = negSigma+tmpSigma;
end
negSigma = negSigma/40;



%预测标签
pLabel = zeros(20,1);
for i=1:20
    
    tmpData = testData(i,:);
    posPost = compute_logGuassianDensity(tmpData,posMiu,posSigma);
    negPost = compute_logGuassianDensity(tmpData,negMiu,negSigma);
    if posPost>negPost
        pLabel(i)=1;
    end
end


%分析结果准确率
acc = 1-sum(abs(pLabel-testLabel))/20;


