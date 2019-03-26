function [mat, summary, fig]=comparingSandU_CML_discrimination(predicted,idx_UML,idx0,n_layer)

% Function "[mat summary fig]=comparingSandU_CML_discrimination(predicted,idx_UML,idx0,n_layer)" 
% compares the clustering results of one area dataset to a reference
% dataset basing on supervised machine learning result.
%
% Input "predicted" is the result of supervised machine learning, which is
% a matrix with the row number equaling to the number of slice, and the column
% number as the number of trials. "idx_UML" is the result of the unsupervised clustering.
% "idx0" is a vector which indicates the label of the selected hierarchy level on the
% reference dataset. "n_layer" indicates the threshold of the minimal number 
% of layers for selecting the hierarchy level to compare. In practice,
% max(idx0)+"n_layer" is the threshold.
%
% The output "mat" is the probability matrix, with the row as the slice and
% the column as the compared reference c-layer. "fig" is the visualized result.
% "summary" is a structure, with four fields "result", "layer", "thickness"
% and "similar", where "result" is the comparison result basing on the maximal 
% value on each row of "mat", "layer" has four number: (1) the number
% of layers from the reference area, (2) the number of found groups, (3) the 
% number of identical layer from the found group, and (4) the number of
% abnormal boundary, meaning that the more superficial layers appear below
% the boundary, "thickness" contains the total thickness of the discriminated
% layers with the unit of slice, and the last element is the total thickness, 
% and "similar" describes the similarity of the discrimination result and
% the reference layers. In the ideal case, when the testing dataset is the
% same as the training dataset, "similar" equals to 1.

maxlable=max(max(idx0));
mat=zeros(size(predicted,1),maxlable);

lastrow=idx_UML(end,:)'-(maxlable+n_layer);
ih_selected=length(find(lastrow>=0));
ir_selected=ih_selected-1;

% 
    for k=1:1:size(idx_UML,2)
        clear idxz0t
        idxz0t=unique(idx_UML(:,k));
        for ik=1:1:size(idxz0t,1)
        idxz0r(find(idx_UML(:,k)==idxz0t(ik)),k)=mean(find(idx_UML(:,k)==idx_UML(ik)));
        end
    end




% figure
% imagesc(idxz0r);
% colormap(jet)
% colorbar

A = idx_UML(:,ih_selected);
m= max(A);

for i=1:m
    ind_i=find(A==i);
    for j=1:max(max(predicted))
    mat(ind_i,j) = (length(find(predicted(ind_i,:)==j)))/(size(predicted,2)*(length(ind_i)));
    end
    
      
end

for i=1:1:size(mat,1)
    Bx=mat(i,:);
    clear Bxx
    Bxx=find(Bx==max(Bx));
    B(i,1)=Bxx(1,1);
    
end



% figure
% %% original result of unsupervised learning
% subplot(2,5,[1:3])
% imagesc(idxz0r);
% colormap(jet)
% axis={'0','1','2','3','4','5','6','7','8','9','10'};
% set(gca,'XTickLabel',axis)
% xlabel('Iteration');
% %% orginal result of supervised learning
% subplot(2,5,[4:5])
% imagesc(predicted);
% colormap(jet)
% colorbar
% xlabel('Trails');
% %% selected level from unsupervised learning
% subplot(2,5,6)
% imagesc(idxz0r(:,ih_selected))
% colormap(jet)
% set(gca,'xtick',[]);
% xlabel(strcat(num2str(ir_selected),'th iteration'));
% %colorbar
% 
% 
% %% comparison to supervised learning
% subplot(2,5,[7:9])
% imagesc(mat)
% axis={'1(II)','2(III)','3(IV)','4(Va)','5(Vb)','6(VI)','7(VI)'};
% set(gca,'XTickLabel',axis)
% colormap(jet)
% colorbar
% 
% %% maximal learning result
% subplot(2,5,10)
% imagesc(B)
% colormap(jet)
% colorbar
% xlabel(strcat(num2str(ir_selected),'th iteration'));
% set(gca,'xtick',[]);

% figure for paper


fig=figure('pos',[10 10 1000 600])

%% original result of unsupervised learning
subplot(2,10,[5:10])
imagesc(idxz0r);
title('B     Unsupervised clustering'); 
colormap(gca,jet(100))
axis={'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36'};
set(gca,'XTickLabel',axis)
xlabel('Iteration');
set(gca,'ytick',[]);
yt = get(gca, 'YTick');                                 % 'YTick' Values
    set(gca, 'YTick', yt, 'YTickLabel', yt*2)
%% orginal result of supervised learning
subplot(2,10,[1:4])
imagesc(predicted);
title('A     Supervised learning'); 


cuni=unique(predicted);
colormap(gca,jet(size(mat,2)))
colorbar
xlabel('Trails');
yt = get(gca, 'YTick');                                 % 'YTick' Values
    set(gca, 'YTick', yt, 'YTickLabel', yt*2)
    ylabel('depth(\mum)');
    
        hcolor = colorbar;
        set(gca, 'clim', [0.5 size(mat,2)+0.5]);
        set(hcolor, 'ticks', 1:size(mat,2)); 
        cylabel=ylabel(hcolor, 'reference c-layer')
        poscy=get(cylabel,'Position');
        poscy1(1,2)=poscy(1,2);
        set(cylabel,'Position',poscy1)
set( hcolor, 'YDir', 'reverse' );
% %% selected level from unsupervised learning
% subplot(2,5,6)
% imagesc(idxz0r(:,ih_selected))
% colormap(jet)
% set(gca,'xtick',[]);
% xlabel(strcat(num2str(ir_selected),'th iteration'));
% yt = get(gca, 'YTick');                                 % 'YTick' Values
%     set(gca, 'YTick', yt, 'YTickLabel', yt*2)
% %colorbar


%% comparison to supervised learning
subplot(2,10,[14:20])
imagesc(mat)
title('C       Combined');
axis={'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36'};
%axis={'1(II)','2(III)','3(IV)','4(Va)','5(Vb)','6(VI)','7(VI)'};
set(gca,'XTickLabel',axis)

colormap(gca,jet(100))
colorbar
set(gca,'ytick',[]);
%xlabel('C-Layer of V1 (and the corresponded Brodmann’s Layer)');
xlabel('c-layer of reference location');
 yt = get(gca, 'YTick');                                 % 'YTick' Values
    set(gca, 'YTick', yt, 'YTickLabel', yt*2);
        hcolor = colorbar;
        
        cylabel=ylabel(hcolor, 'probability')
        poscy=get(cylabel,'Position');
        poscy1(1,2)=poscy(1,2);
        set(cylabel,'Position',poscy1)
%     ylabel('depth(\mum)');
%% maximal learning result
subplot(2,10,[11])
imagesc(B)
title('D'); 



colormap(gca,jet(size(mat,2)))

%xlabel(strcat(num2str(ir_selected),'th iteration'));
set(gca,'xtick',[]);
% set(gca,'ytick',[]);
 yt = get(gca, 'YTick');                                 % 'YTick' Values
    set(gca, 'YTick', yt, 'YTickLabel', yt*2)
      ylabel('depth(\mum)');  
    
    hcolor = colorbar;
        cylabel=ylabel(hcolor, 'reference c-layer')
%         set(hcolor, 'ylim', [0.5,size(cuni,1)+0.5])
        set(gca, 'clim', [0.5 size(mat,2)+0.5]);
        set(hcolor, 'ticks', 1:size(mat,2)); 

        poscy=get(cylabel,'Position');
        poscy1(1,2)=poscy(1,2)*1.5
        set(cylabel,'Position',poscy1)
set( hcolor, 'YDir', 'reverse' );
hcolor.Position(1) = hcolor.Position(1)+0.055;
hcolor.Position(3) = 4.7*hcolor.Position(3);


annotation('rectangle', [0.447+0.0417*ir_selected 0.54 0.0417 0.39])
annotation('rectangle', [0.125 0.51 0.295 0.423])
annotation('rectangle', [0.125 0.09 0.135 0.368])
annotation('rectangle', [0.35 0.0375 0.56 0.418])
annotation('arrow',[0.42 0.53],[0.51 0.47])  
annotation('arrow',[0.4679+0.0417*ir_selected 0.68],[0.54 0.47])  
annotation('arrow',[0.35 0.26],[0.25 0.25])


%% summary
%result
summary.result=B;
%layer
Bb=zeros(size(B,1)-1,1);
    for ibb=1:1:size(B,1)-1
        Bb(ibb,1)=B(ibb+1,1)-B(ibb,1);
    end
summary.layer(1,1)=maxlable;
summary.layer(1,2)=length(find(Bb~=0))+1;
summary.layer(1,3)=length(unique(B));
summary.layer(1,4)=length(find(Bb<0));
%thickness
thickness=zeros(maxlable+1,1);
thickness(maxlable+1,1)=size(B,1);
    for ibt=1:1:maxlable
        thickness(ibt,1)=sum(any(B==ibt,2));
    end
summary.thickness=thickness;
%similar
n_similar=min(size(idx0,1),size(B,1));
d_similar=idx0(1:n_similar,1)-B(1:n_similar,1);
summary.similar=sum(any(d_similar==0,2))/n_similar;
return
