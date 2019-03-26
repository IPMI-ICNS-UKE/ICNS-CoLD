%% Discrimination Main Code
% This code is used to discriminate cortical layers by using the
% high-resolution image data in the folder "data".
% Detailed description of the concept and the method is shown in our paper
% "Discrimination of the hierarchical structure of cortical layers in 2-photon 
% microscopy data by combined unsupervised and supervised machine learning
% -- Dong Li, Melissa Zavaglia1, Guangyu Wang, Yi Hu, Hong Xie, Rene Werner,
% Ji-Song Guan, Claus C. Hilgetag".

%% paramter
Minimal_images_rate=0.75; % minimal image rate used to analysis
%% features selected for hierarchical clustering 
%operation 
n_featureset=6;
% 1
fields_c(1,1).name='features_basic';
fields_c(1,1).column=[1];
% 2
fields_c(2,1).name='features_basic';
fields_c(2,1).column=[1 2];
% 3
fields_c(3,1).name='features_basic';
fields_c(3,1).column=[1];
fields_c(3,2).name='features_sap';
fields_c(3,2).column=[1 2 3 4];
% 4
fields_c(4,1).name='features_basic';
fields_c(4,1).column=[1 2];
fields_c(4,2).name='features_sap';
fields_c(4,2).column=[1 2 3 4];
% 5
fields_c(5,1).name='features_basic';
fields_c(5,1).column=[1 2];
fields_c(5,2).name='features_stats';
fields_c(5,2).column=[1 2 3 4];
% 6
fields_c(6,1).name='features_stats';
fields_c(6,1).column=[1 2 3 4];
% % n_featureset+1 only used for supervised learning
% fields_c(n_featureset+1,1).name='fine_data';
% fields_c(n_featureset+1,1).column=[1 2 3 4 5];
%% evaluation of unsupervised clustering
tolerance=3;
%% Initial groups
nlayer=10;
%% Traing data
nametrainlist=['M226L5';'M248L1';'M248R3';'M262L2';'M262L3';'M262R3';'M339R5';'M339R6'];
clusteringconfigaration='1';
n_trainlayer=8; %Select the traing level of the training data
nr=n_trainlayer+1;
%% supervised learning
n_learn=200; %number of trails of learning
p_out=0.01; % percentage of randomly deleted datapoints in traing set
n_layer=0;
%% end of parameters

cd ..
cd ..
cd('data');
name_folders=ls('M*');


%% unsupervised clustering
for i=1:1:size(name_folders,1)

        cd(name_folders(i,:));
 %% clean folders
        clean_folders_CML_discrimination(name_folders(i,:));
 %% check data
        check_CML_discrimination(name_folders(i,:),Minimal_images_rate);
 %% calculate features 
        clear features
        features=features_CML_discrimination(name_folders(i,:),'nanmean');
 %% hierarchical clustering
 
            mkdir('clustering');
            cd('clustering');
        for i_clustering=1:1:n_featureset
            mkdir(num2str(i_clustering));
            cd(num2str(i_clustering));
            fields=fields_c(i_clustering,:);
            clear feature_matrix
            
 % select features for hierarchical clustering
            feature_matrix=select_features_CML_discrimination(features,fields);
 % hierarchical clustering
 
            idxz0=hierarchical_clustering_CML_discrimination(feature_matrix,nlayer);
            save label.mat idxz0;
            [imtrees,imhierarchy]=visualization_clustering_CML_discrimination(idxz0,'sfig');
            cd ..
        end
            corr_c=evaluation_clustering_CML_discrimination(tolerance);
            cd ..
            mkdir('evaluation')
            cd('evaluation')
            save clustering.mat corr_c
            cd ..
        %%
        cd ..
end
%% supervised learning
%for i_clustering=1:1:n_featureset+1
for i_clustering=1:1:n_featureset
for itrain=1:1:size(nametrainlist,1)
% traing matrix
nametrain=nametrainlist(itrain,:);
cd(nametrain);
cd('feature');
load('feature.mat');
cd ..
cd('clustering')
cd(clusteringconfigaration);
idxz00=load('label.mat');
idxz0=idxz00.idxz0;
cd ..
cd ..
cd ..
            fields=fields_c(i_clustering,:);
            clear feature_matrix
 % select features for traing
            feature_matrix=select_features_CML_discrimination(features,fields);
                if i_clustering<=n_featureset
                    matrix_tr=[feature_matrix idxz0(:,nr)];
                elseif i_clustering==n_featureset+1
                    nx=size(feature_matrix,2)+1;
                    for j=1:1:size(feature_matrix,1)
                    feature_matrix(j,nx)=idxz0(feature_matrix(j,nx-1),nr);
                    matrix_tr=feature_matrix(:,[1:nx-2 nx]);
                    end
                end  
                
                
                
% test
for i=1:1:size(name_folders,1)
    cd(name_folders(i,:));
    cd('feature');
    load('feature.mat');
    cd ..
        cd('clustering')
        cd(clusteringconfigaration);
        idx_UML0=load('label.mat');
        idx_UML=idx_UML0.idxz0;
        cd ..
        cd ..
    mkdir('supervisedlearning')
    cd('supervisedlearning')
            clear feature_matrix
% select features for traing
            feature_matrix=select_features_CML_discrimination(features,fields);
                if i_clustering<=n_featureset
                    testing_instance_matrix=feature_matrix;
                elseif i_clustering==n_featureset+1
                    testing_instance_matrix=feature_matrix(:,1:end-1);
                end
                
                predicted=supervised_learning_CML_discrimination(matrix_tr,testing_instance_matrix,n_learn,p_out);
                mkdir(num2str(i_clustering));
                    cd(num2str(i_clustering));
                    save pred.mat predicted;
                mkdir(strcat(nametrain,'F',clusteringconfigaration,'Nt',num2str(n_trainlayer)))
                cd(strcat(nametrain,'F',clusteringconfigaration,'Nt',num2str(n_trainlayer)))
                        if i_clustering<=n_featureset
                            predictedr=predicted;
                        elseif i_clustering==n_featureset+1
                            predictedr=reshape(predicted,size(idx_UML,1),(size(predicted,1)*size(predicted,2)/size(idx_UML,1)));
                        end
                [mat summary fig]=comparingSandU_CML_discrimination(predictedr,idx_UML,idxz0(:,nr),n_layer);
                save mat.mat mat;
                save summary.mat summary;
                savefig(fig,'Comparision.fig');
                close(fig);
                cd ..
                    cd ..
     cd ..
     cd ..
end
end
end


cd ..
cd('code')
cd('discrimination')