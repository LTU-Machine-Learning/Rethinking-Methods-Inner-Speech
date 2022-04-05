%%Testing code

clear all;
clc;

words_list={'up','down','left','right','forward','backward'};
ratio=[80,10,10];
seed_value=[99,1000,34,389,5000];


%%Path for data and trained models
data_path= 'Where processed data has been saved';
model_save_path= 'Where trained models hasve been saved ';

cl='words'; %  for words
num_trails=5;

%%data information
numOfElectrodes = 6;
channels=1;

              
for j=9 % number of subjects
    if j<10
        subj = ['S0',num2str(j)];
    else
         subj = ['S',num2str(j)];
    end

 %%%loading file to get test data   
 filename1=[data_path,'\words_processed_data_downsampled128','\EEG_inner_',cl,'_', subj, '.mat'];
 words_data=load(filename1);


  % Running program for five random trails
      for trails=1:num_trails
          %%%calling function for making train/test/val data according to ratio
          [train_data,train_lables,val_data,val_lables,test_data,test_lables]=create_TVR_with_ration_words(seed_value(trails),words_data,ratio,words_list);
          %%%reshaping test data according to CNN requirment
          [CnnTestData, CnnTestLabels,height, width]=reshape_CNN(test_data,test_lables,numOfElectrodes,channels);
         

            %%%Loading training models
            filename_model=[model_save_path,'\Testing_TrainedModels\Trained_models_words_downsampled128\Trained_model_',subj,'_',num2str(trails),'.mat']
            load(filename_model);

            %%%Predcition on test data
            predLabelsTest = net.classify(CnnTestData);
            testing_accuracy(j,trails) = sum(predLabelsTest == CnnTestLabels) / numel(CnnTestLabels);
         
      end
end

