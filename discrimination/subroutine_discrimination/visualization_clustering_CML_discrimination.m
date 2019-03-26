function [imtrees,imhierarchy]=visualization_clustering_CML_discrimination(idxz0,save)

% Function "[imtrees,imhierarchy]=visualization_clustering_CML_discrimination(idxz0)"
% or "[imtrees,imhierarchy]=visualization_clustering_CML_1(idxz0,save)" 
% is used to visualize the results of hierarchical clustering.
% The input "idxz0" is the result from the hierarchical clustering. When
% the input "save='sfig'", two figures are saved as "trees.fig" and "layer.fig" respectively.


idxz0s=sum(idxz0,2);

            depth=size(idxz0,1);
ida=zeros(depth-1,3);
ida(1:depth-1,1)=[1:depth-1]';
ida(1:depth-1,2)=[2:depth]';
ida(1:depth-1,3)=idxz0s(2:depth,1)-idxz0s(1:depth-1,1);

idb=sortrows(ida,3);
cn=depth;
for i=1:1:depth-2
g1=idb(i,1);
g2=idb(i,2);
idb(find(idb(i+1:end,1)==g1)+i,1)=cn+1;
idb(find(idb(i+1:end,2)==g1)+i,2)=cn+1;
idb(find(idb(i+1:end,1)==g2)+i,1)=cn+1;
idb(find(idb(i+1:end,2)==g2)+i,2)=cn+1;
cn=cn+1;
end

imtrees=figure(4)
dendrogram(idb,0,'Reorder',[1:depth],'Orientation','right','ColorThreshold','default')
set(gca,'ydir','reverse');

    for k=1:1:size(idxz0,2)
        clear idxz0t
        idxz0t=unique(idxz0(:,k));
        for ik=1:1:size(idxz0t,1)
        idxz0r(find(idxz0(:,k)==idxz0t(ik)),k)=mean(find(idxz0(:,k)==idxz0t(ik)));
        end
    end
imhierarchy=figure(5)
imagesc(idxz0r)
   

if nargin == 2
    if save=='sfig';
        savefig(imtrees,'trees.fig');
        savefig(imhierarchy,'layer.fig');
    end
end
    


return