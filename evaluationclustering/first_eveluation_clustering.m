

%% paramter
 
n_featureset=6;

cd ..
cd ..
cd('data');
name_folders=ls('M*');

n_folder=size(name_folders,1);
n_relation=n_featureset*(n_featureset-1)/2;

matrix_total=zeros(n_featureset,n_featureset,n_folder);
matrix_relation=zeros(n_relation,n_folder);
%% unsupervised clustering
for i=1:1:n_folder

        cd(name_folders(i,:));
        cd('evaluation')
        evaluation=load('clustering.mat');
        matrix_e=getfield(evaluation,'corr_c');
        matrix_total(:,:,i)=matrix_e;
            k=0;
            for jk1=1:1:n_featureset;
                for jk2=jk1+1:1:n_featureset;
                    k=k+1;
                    matrix_relation(k,i)=matrix_e(jk1,jk2);
                end
            end
        
        na=name_folders(i,:)
        %%
        cd ..
        cd ..
end


figure('pos',[200 500 1000 300])
subplot(1,5,1:3)
    for i=1:1:n_folder
fig1=plot(matrix_relation(:,i),'-')
    hold on
    end
legend

subplot(1,5,4:5)
matrix_mean=mean(matrix_total,3)
fig2=imagesc(matrix_mean)
colormap(jet)
colorbar



cd ..
cd('code')
cd('evaluationclustering')
save('matrix_relation.mat','matrix_relation')
save('matrix_mean.mat','matrix_mean')

