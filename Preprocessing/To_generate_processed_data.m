%%%Data preperation with new preprocessing stages
%1. Bandpass filter(2Hz-40Hz), 2. Downsample to 128 Hz 3. FastICA

clear all;
clc;

words_list={'up','down','left','right','forward','backward'};

base_path='Where raw data has been saved';

cl='words'; %  for vowels
numOfElectrodes = 6;
sampling_rate=32;
method='picard';

for j=1:15 % number of subjects
    
    if j<10
        subj = ['S0',num2str(j)];
    else
        subj = ['S',num2str(j)];
    end

    filename1=[base_path,'\EEG_inner_',cl,'_', subj, '.mat'];
    unprocessed_data=load(filename1);

    unprocessed_data=unprocessed_data.EEG_inner_words;
    word_data=prepro_DFICA_for_words(unprocessed_data,sampling_rate,method,numOfElectrodes,words_list);
    
    filename_a='Path for saving processed data';
    save(filename_a, '-struct', 'word_data');  
   
end