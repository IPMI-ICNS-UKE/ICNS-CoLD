function idx=sub_neuron_classificatoin_SAP_CML_discrimination(sz2,vsz2)

% Function "sub_neuron_classificatoin_SAP_CML_discrimination(sz2,vsz2)"
% is used to classify the neurons basing on their size and shape into two group
% by using function "fitgmdist". The label of the classification results are 
% re-ranked from small mean size within a group to big. 
        
        neurontype=2;
        p(:,1)=log(sz2);
        p(:,2)=log(vsz2);
        
warning off % not dispalay warning "Rows of X with missing data will not be used. "
        GMModel = fitgmdist(p,neurontype);
        idx = cluster(GMModel,p);
warning on     
        %% relabel
        msidx=zeros(neurontype,2);
        msidx(:,1)=[1:neurontype]';
        for iid=1:1:neurontype
            msidx(iid,2)=nanmean(p(find(idx==iid),1));
        end
        msidxs=sortrows(msidx,2);
        idxminus=-idx;
        for iid=1:1:neurontype
        idxminus(find(idx==msidxs(iid,1)),1)=-iid;
        end
        idx=-idxminus;
return