function idxz0=hierarchical_clustering_CML_discrimination(feature_matrix,nlayer,weight_matrix)

% Function "idxz0=hierarchical_clustering_CML_discrimination(feature_matrix,nlayer)"
% or "idxz0=hierarchical_clustering_CML_1(feature_matrix,nlayer,weight_matrix)"
% use features given by "feature_matrix" to cluster the hierarchical
% layers. Input "nlayer" gives the number of the groups after the
% first interation, which is the same as the number of total iterations. When input
% "weight_matrix" is given, at every iteration step, the new features will
% calculated by weighted average. The default case is unweighted average.
%
% The output is a matrix, with "nlayer+1" columns. The first column shows the
% labels of the original slice, and all the other columns show the
% clustered layers.




if nargin == 2
    weight_matrix=ones(size(feature_matrix,1),size(feature_matrix,2));
elseif nargin ==3
    if size(feature_matrix)~=size(weight_matrix)
    error(message('XXX'));    
    end
elseif nargin ~= 2 && nargin ~= 3
    error(message('XXXX'));    
end

%
depth=size(feature_matrix,1);
nf=size(feature_matrix,2);
            idxz0=zeros(depth,nlayer+1);
            idxz0o=zeros(depth,nlayer+1);
            idxz0(:,1)=[1:depth]';
            idxz0o(:,1)=[1:depth]';
            idbsub=zeros(depth-1,3,nlayer);
            for in=nlayer:-1:1
                inr=nlayer+1-in;
                
                    clear idui 
                    idui=unique(idxz0(:,inr));
                    feature_matrix0=zeros(depth,nf);
                        for j=1:1:size(idui,1)
                            clear ifeature_matrix0
                            ifeature_matrix0=find(idxz0(:,inr)==idui(j));
                            
                            
                            for k=1:1:nf
                                    feature_matrix0(ifeature_matrix0,k)=mean(feature_matrix(ifeature_matrix0,k).*weight_matrix(ifeature_matrix0,k),1);
                            end
                            
                            
                        end
                        %% normalize matrix
                            for k=1:1:nf
                                    feature_matrix0(:,k)=feature_matrix0(:,k)/sum(feature_matrix0(:,k));
                            end
                                    idbsub(:,:,inr) = linkage(feature_matrix0,'ward','euclidean');
                                    idxzt = cluster(idbsub(:,:,inr),'maxclust',in);
                             idxz0o(:,inr+1)=idxzt;
                idxzt0=1; 
                idxz0(1,inr+1)=idxzt0;
                for ii=2:1:depth
                    if idxzt(ii,1)==idxzt(ii-1,1)
                        idxzt0=idxzt0;
                    elseif idxzt(ii,1)~=idxzt(ii-1,1)
                        idxzt0=idxzt0+1;
                    end
                    idxz0(ii,inr+1)=idxzt0;
                end
                
                
            end
       

return