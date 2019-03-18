%Composed by Tomas Vicar 15/03/2019, 
% Department of Biomedical Engineering, Brno University of Technology  
% vicar@feec.vutbr.cz

clc;clear all;close all;
addpath('utils')
mkdir('tmp')

data_folder='..\preulozene_na_poslani\';%set the data folder


train=1; %set to 0 for test

listing=subdir([data_folder '*.xlsx']);
listing={listing(:).name};

XTrain={};
YTrain={};
XTest={};
YTest={};

for name=listing
    name{1}
    name_table=name{1};
    name_tmp=name{1}(1:end-5);
    name_mask=[strrep(name_tmp,'labels_','mask_') '.tif'];
    name_qpi=[strrep(name_tmp,'labels_','QPI_') '.tif'];
    name_features=[strrep(strrep(name_tmp,'labels_','features_'),data_folder,'tmp\') '.mat'];
    
    
    T=readtable(name_table);
    
    load(name_features)
    
    for k=1:size(T,1)
        
        death_pos=T.death_frame(k);
        death_pos(isnan(death_pos))=100000;
        
        signals=[];
        fields = fieldnames(features);
        for i=1:numel(fields)
            signals=[signals;[features(k).(fields{i})]];
        end
        
        label=gaussmf(1:size(signals,2),[50 death_pos]);
        
        if name_tmp(end)~='7'
              XTrain=[XTrain,signals];
              YTrain=[YTrain,label]; 
        else
              XTest=[XTest,signals];
              YTest=[YTest,label]; 
        end
    
    end
end


XTrain_aug=XTrain;
YTrain_aug=YTrain;
for k=1:size(XTrain,2)
    
    for kk=1:5
        pom=XTrain{k};
        pomy=YTrain{k};
        
        delka=round(size(pom,2)-0.3*rand()*size(pom,2));
        kde=randi(size(pom,2)-delka+1);
        
        
        XTrain_aug=[XTrain_aug,pom(:,kde:kde+delka-1)];
        YTrain_aug=[YTrain_aug,pomy(:,kde:kde+delka-1)];
    end
    
end
XTrain=XTrain_aug;
YTrain=YTrain_aug;









numResponses = size(YTrain{1},1);
featureDimension = size(XTrain{1},1);


numHiddenUnits = 100;
layers = [ ...
    sequenceInputLayer(featureDimension)
    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(100)
    reluLayer
    dropoutLayer(0.5)
    fullyConnectedLayer(50)
    reluLayer
    dropoutLayer(0.5)
    fullyConnectedLayer(100)
    fullyConnectedLayer(numResponses)
    regressionLayer];


save_name=['models'];
mkdir(save_name)
options = trainingOptions('adam', ...
    'GradientThreshold',1,...
    'L2Regularization', 1e-5, ...
    'InitialLearnRate',1e-3,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',1e-8,...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',100, ...
    'LearnRateDropFactor',0.1, ...
    'ValidationData',{XTest,YTest}, ...
    'ValidationFrequency',30, ...
    'Epsilon',1e-8,...
    'MaxEpochs', 40, ...
    'MiniBatchSize', 256, ...
    'Shuffle', 'every-epoch', ...
    'Plots', 'training-progress',...
    'CheckpointPath', save_name);


if train
    net = trainNetwork(XTrain,YTrain,layers,options);

    save('tmp/model.mat','net')
    
else
    load('tmp/model.mat')
end



YTest_pred=predict(net,XTest);


correct=[];
for k=1:size(YTest,2)
    
    
    y=YTest{k};
    y_pred=YTest_pred{k};

    tresh=0.4;

    [m,i]=max(y);
    [m_pred,i_pred]=max(y_pred);
    
    i(m<0.5)=-500;
    i_pred(m_pred<0.5)=-500;

    
    correct=[correct abs(i-i_pred)<100];

end

acc=sum(correct)/numel(correct)


for k=1:20 %show few examples of predictions
    
    y=YTest{k};
    y_pred=YTest_pred{k};

    [m,i]=max(y);
    [m_pred,i_pred]=max(y_pred);
    
    
    figure()
    plot(y)
    hold on
    plot(y_pred)
    
    if m_pred>tresh
        plot(i_pred,m_pred,'*')
    end
    
    ylim([0 1.1])
    drawnow;

end



    