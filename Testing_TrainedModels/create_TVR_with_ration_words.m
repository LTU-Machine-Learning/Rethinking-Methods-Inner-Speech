function [train_data,train_labels,val_data,val_labels,test_data,test_labels]=create_TVR_with_ration_words(seed_value,word_data,ratio,words_list)
rng(seed_value);

for tt=1:length(words_list)
      kk=word_data.(words_list{tt});
      len_v(tt,1)=size(kk,1);
      data{1,tt}=kk;
end

choosen_indi=min(len_v);
%max_indi=max(len_v);
%ran_indi=randperm(max_indi);
[trainInd,valInd,testInd] = dividerand(choosen_indi,ratio(1),ratio(2),ratio(3));

train_data=[];train_labels=[];
test_data=[];test_labels=[];
val_data=[];val_labels=[];

for pp=1:length(words_list)
    datas=data{1,pp};
    tr=datas(trainInd,:);
    tr_la=zeros(numel(trainInd),1)+pp;
    val=datas(valInd,:);
    val_la=zeros(numel(valInd),1)+pp;
    if (choosen_indi==len_v(pp))
        ts=datas(testInd,:);
        ts_la=zeros(numel(testInd),1)+pp;
    else
        updets=setdiff(1:len_v(pp),1:choosen_indi);
        testInd_updated=[testInd updets];
        ts=datas(testInd_updated,:);
        ts_la=zeros(numel(testInd_updated),1)+pp;
    end
    train_data=[train_data;tr];
    test_data=[test_data;ts];
    val_data=[val_data;val];

    train_labels=[train_labels;tr_la];
    val_labels=[val_labels;val_la];
    test_labels=[test_labels;ts_la];
end

end
