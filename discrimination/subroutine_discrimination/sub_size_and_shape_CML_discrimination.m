function [somasize,vsomasize]=sub_size_and_shape_CML_discrimination(rawdata,position)

% Function "sub_size_and_shape_CML_discrimination(rawdata,position)"
% is used to calculate the 2D size and shape of a neuron from one image.
 
%% variables
sp=size(rawdata);
nnumber=size(position);
somasize=zeros(nnumber(1),1);
vsomasize=zeros(nnumber(1),1);
%% parameters
image_size=512;
leng=24;
upb=702; %3.14*15^2
bottomb=12; %3.14*2^2
%%
for i=1:1:nnumber(1)
ix=position(i,1);
iy=position(i,2);
iz=position(i,3);


%% x-y
lengy1=leng;
lengy2=leng;
lengx1=leng;
lengx2=leng;
if iy<=lengy1
    lengy1=iy-1;
end
if (iy+lengy2)>sp(2)
    lengy2=sp(2)-iy;
end

if ix<=lengx1
    lengx1=ix-1;
end
if (ix+lengx2)>sp(1)
    lengx2=sp(1)-ix;
end

clear a x meanx dmx xsl xslo yslo zslo
x=double(rawdata(iy-lengy1:iy+lengy2,ix-lengx1:ix+lengx2,iz));
meanx=mean(mean(x));
dmx=x-meanx;
dmx=dmx-0.333*dmx(lengy1+1,lengx1+1);
dmx=dmx.*dmx(lengy1+1,lengx1+1);
xsl=sign(dmx)-ones(lengy1+lengy2+1,lengx1+lengx2+1);
xslo=logical(xsl);
yslo=imfill(xslo,[lengy1+1 lengx1+1],4);
zslo=yslo-xslo;


[a(:,1), a(:,2)]=find(zslo~=0);
somasize(i)=sum(sum(zslo))*0.992; % 0.996*0.996

%% nan
if somasize(i)>upb || somasize(i)<bottomb
    somasize(i)=nan;
    vsomasize(i)=nan;
elseif somasize(i)<=upb && somasize(i)>=bottomb
%% vsomasize
clear asize ax1 ax2 ay1 ay2 vw vwmax;
asize=size(a);
ax1=ones(asize(1),1)*a(:,1)';
ax2=a(:,1)*ones(asize(1),1)';
ay1=ones(asize(1),1)*a(:,2)';
ay2=a(:,2)*ones(asize(1),1)';
vw=(ax1-ax2).*(ax1-ax2)+(ay1-ay2).*(ay1-ay2);
vwmax=max(max(vw))*0.7791; %3.1415/4*0.996*0.996
vsomasize(i)=vwmax/somasize(i);
end




end

return
