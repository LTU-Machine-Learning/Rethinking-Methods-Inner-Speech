function word_data=prepro_DFICA_for_words(original_data,sampling_rate,method,numOfElectrodes,words_list)

%%%preparing data vowel wise

original_data_without_label=original_data(:,1:end-3);
data_labels=original_data(:,end-1);
word_up_data=original_data_without_label(find(data_labels==6), :);
word_down_data=original_data_without_label(find(data_labels==7), :);
word_right_data=original_data_without_label(find(data_labels==8), :);
word_left_data=original_data_without_label(find(data_labels==9), :);
word_forward_data=original_data_without_label(find(data_labels==10), :);
word_backward_data=original_data_without_label(find(data_labels==11), :);

EEG_word.up=word_up_data;
EEG_word.down=word_down_data;
EEG_word.right=word_right_data;
EEG_word.left=word_left_data;
EEG_word.forward=word_forward_data;
EEG_word.backward=word_backward_data;

clear original_data_without_label data_labels word_up_data word_down_data
clear word_right_data word_left_data word_forward_data word_backward_data original_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Required filter parameters
n1=372;
Wn1=2;
n2=1204;
Wn2=40;

sampling_freq=1024;
Nquist_rate=sampling_freq/2;

low_freq_in_rad_sample=(Wn1/Nquist_rate)*pi;
high_freq_in_rad_sample=(Wn2/Nquist_rate)*pi;

low_pass_fliter = fir1(n1,low_freq_in_rad_sample,'low');
high_pass_filter = fir1(n2,high_freq_in_rad_sample,'high');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%loading data corresponds to a vowel 
for tt=1:length(words_list)
      words_data=EEG_word.(words_list{tt});
      %%%apply to all repeatations of a vowel
      downsampleEEG=[];
      for pp=1:size(words_data,1)
         original_signal=words_data(pp,:);

         %%%2Hz to 40Hz digital band-pass filter; implemeted with low and high pass
         Signal_L=filter(low_pass_fliter,1,original_signal);
         Signal_LH=filter(high_pass_filter,1,Signal_L);

         %%Downsampling of data to 128Hz (1024/128; i.e. 8th sample form the series)
         downsampleData=downsample(Signal_LH,sampling_rate);
         downsampleEEG(pp,:)=downsampleData;
      end
     
      %%reshaping for: Artefact removal and detection using ICA
      arrge_data_SET=reshape_for_arefact_removal(downsampleEEG,numOfElectrodes);
       clear downsampleEEG downsampleData
      %%adding path to run picard algorithm
      addpath('\picard-master\matlab_octave') 
      %%Artefact removal and detection using ICA/FastICA
      whiten = 1;         % Set to 1 and picard whitens the data
      proc_signal=[];
      for k=1:size(arrge_data_SET,1)
        tmp=squeeze(arrge_data_SET(k,:,:));
        tmp_1=tmp';
            if strcmp(method, 'picard')
            Data_ICA = picard(tmp, 'whiten', whiten);
            elseif strcmp(method, 'fastICA')
            Data_ICA = fastICA(tmp, numOfElectrodes);
            end
        Data_ICA=Data_ICA';
        proc_signal(k,:)=(Data_ICA(:)');
    end
word_data.(words_list{tt})=proc_signal;
end

end