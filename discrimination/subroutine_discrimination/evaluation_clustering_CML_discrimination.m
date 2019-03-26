function corr_c=evaluation_clustering_CML_discrimination(tolerance)

% Function "corr_c=evaluation_clustering_CML_discrimination(Tolerance)"
% evaluates the similarity of the clustering results achieved from different
% feature sets with the uncertainty "tolerance" in the spatial resolution.
% Output 'corr_c' is a matrix, where every entry is the similarity between
% two feature set on its row and column, respectively. The values vary
% from -1 to 1. 

    name_conf=ls('*');
    time_s=[];
    for i_conf=1:1:size(name_conf,1)
        folder_name=name_conf(i_conf,:);
        if folder_name(1,1)~='.'
            cd(folder_name(1,:))
            idxz00=load('label.mat');
            idxz0=idxz00.idxz0;
                dis=sum(idxz0,2);
                boundary=zeros(size(dis,1)-1,1);
                for ib=1:1:size(dis,1)-1
                    boundary(ib,1)=dis(ib+1,1)-dis(ib,1);
                end
%                 d_boundary=zeros(size(boundary,1)-1,1);
%                 for ib=1:1:size(boundary,1)-1
%                     d_boundary(ib,1)=boundary(ib+1,1)-boundary(ib,1);
%                 end
%                 time_ss=abs(d_boundary);
%                 time_ss=abs(boundary);
                 time_ss=boundary;
                time_ss=smooth(time_ss,tolerance);
                time_s=[time_s time_ss];
            cd ..
        end
        
    end
%    time_ss=reshape(time_s,size(idxz0,1)-2,size(name_conf,1)-2);
    corr_c=corrcoef(time_s);

return