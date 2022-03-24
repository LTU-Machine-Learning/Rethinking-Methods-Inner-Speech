function [CnnData, CnnLabels,height, width]=reshape_CNN(train_data,train_lables,numOfElectrodes,channels)

num_of_T_Samples=size(train_data,2)/numOfElectrodes;


for t=1:size(train_data,1)
        eegdataAllElectrodes=train_data(t,:);
        for k=1:numOfElectrodes
            EEG_data(t,k,:)=eegdataAllElectrodes(1,(k-1)*num_of_T_Samples+1:k*num_of_T_Samples);
        end
end


sampleSize = size(EEG_data,1);
height = size(EEG_data,2);
width = size(EEG_data,3);

CnnData = reshape(EEG_data,[height, width , channels, sampleSize]);
CnnLabels = categorical(train_lables);

end


