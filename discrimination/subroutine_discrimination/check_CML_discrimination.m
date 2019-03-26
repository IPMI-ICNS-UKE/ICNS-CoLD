 function ctest=check_CML_discrimination(MouseArea,Minimal_Images)
 
% Function "check_CML_discrimination(MouseArea,Minimal_Images)"
% is used to check if every folder under the study is well prepared.
%
% First, the name of the folder should be in the form "Mouse name"+"Area
% name", e.g. "M248L1", where "M248" is the name of the mouse and "L1" the 
% name of the area. This folder name will also be the first variable
% of the function, i.e. "MouseArea". 
%
% In each folder, there should be one ".mat" file and a set of 2-photon
% neural imaging ".tif" files.
%
% One field of the ".mat" file contains the position information of the neurons, 
% which is named in the form of "Folder name"+position, e.g. M248L1position. 
%     
% The second variable "Minimal_Images" indicates the minimal percentage of the  
% number of the ".tif" files which wil be used for further analysis. Its
% range is from 0 to 1.
%
% The function looks for the top "Minimal_Images" percentage images with the 
% order from high slice number to low, and then gets the minimal amount of 
% the slices within those selected images, and at the end returns all the names of the 
% ".tif" files, whose slice number is not less than this minimal amount, into a
% ".csv" file. Meanwhile, the number of the potentially used image files and
% the minimal amount of the slice will be exported into a .txt file.
%
% At last, this minimal number of slice is also written down into a flie named as
% "slicenumber.dat".



%% load position
dataname=ls('*.mat');

alldata=load(dataname);
position_check=strcat(MouseArea,'position');
position_check_filedname=fieldnames(alldata);
[LIA,LOCB]=ismember(position_check_filedname,position_check);

if sum(LOCB)>0
    position=getfield(alldata,position_check);
elseif sum(LOCB)==0
    disp('There is not a relevant position information.')
    pause
end


%%
nnumber=size(position);
%% file name
namelist=ls('*.tif');
nname=size(namelist);

%% check if all images have the same level
imaif=zeros(nname(1),1);
for iname=1:1:nname(1)
clear imaifx
imaifx=imfinfo(namelist(iname,:));
imaif(iname,1)=size(imaifx,1);
end


if std2(imaif)~=0
    'The images have different levels'
    MouseArea
    imaif
        imaif_sorted=sort(imaif);
        istart=fix(size(imaif,1)*(1-Minimal_Images)-1e-10)+1;
        slice_required=imaif_sorted(istart,1);
        namelist_filtered=namelist(find(imaif>=slice_required),:);
elseif std2(imaif)==0
    'The images have the same level'
    MouseArea
        slice_required=imaif(1,1)
        namelist_filtered=namelist;
end

    namelist_filtered_size=size(namelist_filtered,1);
    
    fo=fopen('Amounts of slices.txt','wt');
    fprintf(fo,'The minimal sclices number under use is ');
    fprintf(fo, '%i', slice_required);
    fprintf(fo,'\n');
    fprintf(fo,'The number of images under use is ');
    fprintf(fo, '%i', namelist_filtered_size);
    fclose(fo);
    
    fo2=fopen(strcat('namelistLE',num2str(slice_required),'.csv'),'wt');
    for ii=1:1:namelist_filtered_size
    fprintf(fo2,'%s',namelist_filtered(ii,:));
    fprintf(fo2,'\n');
    end
    fclose(fo2);
    
    fo3=fopen(strcat('slicenumber.dat'),'wt');
    fprintf(fo3, '%i', slice_required);
    fclose(fo3);
    
 return;
