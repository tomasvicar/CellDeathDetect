function [teckyy,masky_jadraa]=detekce(qpi,dapi)


area_change=0.85;
delta=5;
min_area=80;
maximum_v_okoli=6;


ab=dapi;
a=qpi;

I=uint8(255*mat2gray(imgaussfilt(ab,1)));



[r,~]=vl_mser(I,'MinDiversity',0.4,...
    'MaxVariation',area_change,...
    'Delta',delta,...
    'MinArea', min_area/ numel(I),...
    'MaxArea',1);

M1 = zeros(size(I)) ;
for x=1:length(r)
    s = vl_erfill(I,r(x)) ;
    M1(s) = M1(s) + 1;
end




suma=M1;

maska_jadra=suma>0;

% imshow(maska_jadra,[]);

m=(watershed((-suma))>0)&maska_jadra;
m=imfill(m,'holes');

m=bwareafilt(m,[min_area 99999999]);


pom3=centroid_mask(m);

mmp=zeros(size(m));
pom1=imgaussfilt(a,3);
pom2=imerode(m,strel('disk',maximum_v_okoli))|pom3;
l=bwlabel(pom2);
% tic
for pp=1:max(l(:))
    pom2=l==pp;
    pom3=pom1.*pom2;
    [px,py]=find(pom3==max(pom3(:)),1);
    mmp(px,py)=1;
end
% toc
m=mmp;


mpp=centroid_mask(m);

teckyy=mpp;
masky_jadraa=maska_jadra;


