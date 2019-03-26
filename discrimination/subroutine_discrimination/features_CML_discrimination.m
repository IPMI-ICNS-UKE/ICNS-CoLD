function features=features_CML_discrimination(MouseArea,average_method)

% Function "cfeatures=features_CML_discrimination(MouseArea,average_method)"
% calculates the features of the data within the folder "MouseArea". 
%
% A subfolder named as "feature" is created, in which a .mat file named
% "Feature.mat" is exported.
%
% Feature.mat has four fields:
% The first one named as "features_basic" has two columns, i.e. the total
% neuron density and their mean size on each slice.
% The second one named as "features_sap" contains the features while
% neurons are classified by using their size and shape into two groups, and
% show their ratios and mean sizes on each slice, respectively.
% All the results of the first two kinds of features have been smoothed by
% using the total mean size of neurons.
% The third field named as "features_stats" contains the image texture  
% features, which are calculated by using the function "graycoprops". 
% Results are averaged over all the images available in the folder.
% The last filed named as "fine_data" summarizes the image features of every
% images on the first four columns, and on the fifth column is their depth
% in each image.
% 
% The variable "average_method" could either equals to "nanmean" or "rbstfit".
% When multiple images for any one animal are used for research, mean values 
% of certain variables need to calculated in order to calculate the final 
% features. "nanmean" means the function "nanmean" is used to calculate the
% mean values, and "rbstfit" means the function "robustfit" is used to
% calculate the mean values. When the number of images is smaller than 3,
% "robustfit" will not work. 

%% parameters
image_size=512;
leng=24;
upb=702; %3.14*15^2
bottomb=12; %3.14*2^2
numtype=2;
% sred=3;
C={'%6.3d ';'\n'};
%% slice
datfile=ls('*.dat');
amount_slice=load(datfile(1,:));
%% load position
dataname=ls('*.mat');
alldata=load(dataname);
position_check=strcat(MouseArea,'position');
position=getfield(alldata,position_check);
% cut off neurons
position_cut=position(position(:,3)<=amount_slice,:);
position_cut(any(position_cut<1,2),:)=[];
position_cut(any(position_cut(:,1:2)>image_size,2),:)=[];
%% read name table
csvfile=ls('*.csv');
fid = fopen(csvfile);
namecell = textscan(fid, '%s');
fclose(fid);
namelist=namecell{1,1};
amount_images=size(namelist,1);

%% statistical features
features_m=zeros(amount_slice,4);

somasize=zeros(size(position_cut,1),amount_images);
vsomasize=zeros(size(position_cut,1),amount_images);
for i=1:1:amount_images
    image_name=namelist{i,1};
    image_data=zeros(image_size,image_size,amount_slice);
        for j=1:1:amount_slice
        image_data(:,:,j)=imread(image_name,j);
        feature_stats = graycoprops(image_data(:,:,j));
        % i counts the images, and j the depth
            features_im(i,j,1)=feature_stats.Contrast;
            features_im(i,j,2)=feature_stats.Correlation;
            features_im(i,j,3)=feature_stats.Energy;
            features_im(i,j,4)=feature_stats.Homogeneity;
        end
        %% size and shape    
    [somasize(:,i),vsomasize(:,i)]=sub_size_and_shape_CML_discrimination(image_data,position_cut);
end

% replace all th evalues of 1 -1 or 0 with nan
        features_im(find(features_im==0))=nan;    
        features_im(find(features_im==-1))=nan;    
        features_im(find(features_im==1))=nan;
        
% robiust fit of all the four features
warning off % not dispalay warning while doing robustfit
for j=1:1:amount_slice
    for k=1:1:4
        ffxa=features_im(:,j,k);
    if size(ffxa(isnan(ffxa)==0),1)>=3
    
    if average_method=='rbstfit'
        [sb,stats]=robustfit(zeros(1,amount_images),features_im(:,j,k));
        features_m(j,k)=sb(1);
    end
    if average_method=='nanmean'   
        features_m(j,k)=nanmean(features_im(:,j,k));
    end
    
    elseif size(ffxa(isnan(ffxa)==0),1)<3
    features_m(j,k)=nan;  
    end
    end
end
warning on 

%% classified neurons


sz2=zeros(size(position_cut,1),1);
vsz2=zeros(size(position_cut,1),1);
% average

if average_method=='rbstfit'
warning off % not dispalay warning while doing robustfit
for i=1:1:size(position_cut,1)
    if numel(find(isnan(somasize(i,1:amount_images))))+3>amount_images
        sz2(i)=nan;
        vsz2(i)=nan;
    elseif numel(find(isnan(somasize(i,1:amount_images))))+3<=amount_images
        clear sb stats
        [sb,stats]=robustfit(zeros(1,amount_images),somasize(i,1:amount_images));
        sz2(i)=sb(1);
        clear sb stats
        [sb,stats]=robustfit(zeros(1,amount_images),vsomasize(i,1:amount_images));
        vsz2(i)=sb(1);
    end
end
warning on 
end

if average_method=='nanmean'
for i=1:1:size(position_cut,1)
        sz2(i)=nanmean(somasize(i,1:amount_images));
        vsz2(i)=nanmean(vsomasize(i,1:amount_images));
end
end




idx=sub_neuron_classificatoin_SAP_CML_discrimination(sz2,vsz2);

%%

w(:,1)=position_cut(:,3);
w(:,2)=idx(:,1);
w(:,3)=sz2(:,1);

maz=zeros(amount_slice,6);
for i=1:1:amount_slice
%    maz(i,1)=i; %*2*nf; %i*1.1547*nf; %2/sqrt(3)
%     maz(i,1)=1; 
    clear mte mtew smtew;    
    mte=find(w(:,1)==i);
    mtew=w(mte,:);
    smte=size(mte,1);
    maz(i,5)=smte;
    maz(i,6)=nanmean(mtew(:,3),1);
                  for j=1:1:numtype
                      clear nte ntew snte rnte mnsize stdsize;
                      nte=find(mtew(:,2)==j);
                      ntew=mtew(nte,:);
                      snte=size(nte,1);
                      rnte=snte/smte;
                      mnsize=nanmean(ntew(:,3),1);
                      maz(i,j)=rnte;
                      maz(i,numtype+j)=mnsize;
                  end
end
maz(:,5)=maz(:,5)/(image_size*image_size*0.996*0.996);

meanw3=nanmean(w(:,3));
meandm=sqrt(meanw3/3.14)*2;
    sspan=fix(meandm/2)*2+1; %/2 means diveied by the z resolution which is 2 mium
    maz(isnan(maz)==1)=0;
    for j=1:1:numtype*2+2
         maz(:,j)=smooth(maz(:,j),sspan);
    end
    
    

%% fine date features_im
fine_data_features_im=reshape(features_im,amount_slice*amount_images,4);
fine_data_features_im(:,5)=repelem([1:amount_slice]',amount_images);

 
%% Result of features
features.features_basic=[maz(:,5:6) [1:amount_slice]']; % total density and mean size
features.features_sap=[maz(:,1:4) [1:amount_slice]']; % ratios of two classified neurons and their meansize
features.features_stats=[features_m [1:amount_slice]']; % images features
features.fine_data=fine_data_features_im;
%features.fine_data=fine_data_features_im(isnan(fine_data_features_im(:,1))==0,:);

%% output

mkdir('feature')
cd('feature')
save('Feature.mat','features');
cd .. 
return