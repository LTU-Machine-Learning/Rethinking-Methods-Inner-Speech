clear all;
clc;

vowels_list=['a','e','i','o','u'];
ratio=[80,10,10];
seed_value=[99,1000,34,389,5000];


data_path='Where processed data has been saved';
cl='vowels'; %  for vowels
num_trails=5;

%%data information
numOfElectrodes = 6;
sampling_rate=128;


%%% CNN parameters
InLeR=0.001;MBS=10;VF=5;VP=30;leRaS='piecewise';
numF=20;  %% Number of Filters
dr=0.0002;  %% Dropout
reg_f=.001;  %%Regularization value

channels=1;
height=6;
width=4*sampling_rate; % where 4 is time in seconds.
numOfClasses=length(vowels_list);

%%CNN architecture
layers = [
imageInputLayer([height width channels])
% 1a and 1 b
convolution2dLayer([1,5], numF) % numF 'same'
convolution2dLayer([6,1], numF) % numF 'same'
batchNormalizationLayer
leakyReluLayer
% 2
dropoutLayer(dr)
convolution2dLayer([1,5],numF) % 2*numF
batchNormalizationLayer
leakyReluLayer
averagePooling2dLayer([1,2])          
% 3
dropoutLayer(dr)
convolution2dLayer([1,3],2*numF) % 2*numF
batchNormalizationLayer
leakyReluLayer
averagePooling2dLayer([1,2])
% 4
dropoutLayer(dr)
convolution2dLayer([1,3],100) % 2*numF
batchNormalizationLayer
leakyReluLayer
averagePooling2dLayer([1,2])
% 5
dropoutLayer(dr)
convolution2dLayer([1,3],250) % 2*numF
batchNormalizationLayer
leakyReluLayer
averagePooling2dLayer([1,2])
% 6
dropoutLayer(dr)
convolution2dLayer([1,3],500) % 2*numF
batchNormalizationLayer
leakyReluLayer
averagePooling2dLayer([1,2])
fullyConnectedLayer(numOfClasses)
softmaxLayer
classificationLayer];

               
%% Data split and training under five trails                    
              
for j=1:15 % number of subjects
    if j<10
        subj = ['S0',num2str(j)];
    else
         subj = ['S',num2str(j)];
    end
    
    filename1=[data_path,'\vowel_processed_data_downsampled128','\EEG_inner_',cl,'_', subj, '.mat'];
    vowel_data=load(filename1);


  % Running program for five random trails
      for trails=1:num_trails
          %%%calling function for making train/test/val data according to ratio
          [train_data,train_lables,val_data,val_lables,test_data,test_lables]=create_TVR_with_ration_vowel(seed_value(trails),vowel_data,ratio,vowels_list);
          
          %%%To check data to ahve all classes
          [cnt_unique_tr, unique_tr] = hist(train_lables,unique(train_lables));
          [cnt_unique_val, unique_val] = hist(val_lables,unique(val_lables));
          [cnt_unique_ts, unique_ts] = hist(test_lables,unique(test_lables));

          %%%reshaping input according to CNN requirment
          [CnnTrainData, CnnTrainLabels,height, width]=reshape_CNN(train_data,train_lables,numOfElectrodes,channels);
          [CnnValData, CnnValLabels,height, width]=reshape_CNN(val_data,val_lables,numOfElectrodes,channels);
          [CnnTestData, CnnTestLabels,height, width]=reshape_CNN(test_data,test_lables,numOfElectrodes,channels);
          

           %%%remove unnessacry varibale
           clear train_data train_lables val_data val_lables test_data test_lables cnt_unique_tr cnt_unique_ts cnt_unique_val unique_tr unique_ts unique_val
       
           %%% Training options
           options = trainingOptions( 'adam',...
           'maxEpochs' ,60,...
           'InitialLearnRate',InLeR,...
           'MiniBatchSize', MBS,...
           'Verbose', false,...
           'LearnRateSchedule', leRaS,...
           'L2Regularization', reg_f,...
           'ValidationFrequency',VF,...
           'Shuffle','every-epoch',...
           'ValidationData',{CnnValData, CnnValLabels},...
           'ValidationPatience',VP, ...
           'OutputNetwork','best-validation-loss');      

            %%%Training models
            [net,info] = trainNetwork(CnnTrainData, CnnTrainLabels, layers, options);

             %%%Predcition
              predLabelsVal = net.classify(CnnValData);
              validation_accuracy(j,trails) = sum(predLabelsval == CnnValLabels) / numel(CnnValLabels);
         
      end
end

