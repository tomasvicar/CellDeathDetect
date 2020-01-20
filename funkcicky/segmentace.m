function rosekana=segmentace(qpi,dapi,rosekana_old)

sigma=4;
vaha=0.5;
kolik_erodovat=4;
a=dapi;



pozadi_er_old=~imdilate(rosekana_old,strel('disk',kolik_erodovat));

rosekana_er_old=imerode(rosekana_old,strel('disk',kolik_erodovat));

l=bwlabel(rosekana_old);
ml=max(l(:));
l=l.*double(rosekana_er_old);
pom=zeros(size(l));
for k=1:ml
   b=k==l;
   b= bwareafilt(b,1);
   pom=pom+b;
    
end
rosekana_er_old=pom;



% maska=segmentace_popredi(qpi);
maska=segmentace_popredi_dapi(dapi);

D = bwdistgeodesic(maska>0,rosekana_er_old>0,'quasi-euclidean');
D=D;
D(maska==0)=99999999;
hranice=(watershed(D)==0).*(maska>0);

pom=zeros(size(D));

D = bwdistgeodesic(maska>0,hranice>0,'quasi-euclidean');
% D(D==Inf)=0;
% gau=exp(D.^2./(2*sigma^2));
gau=pdf('norm',D,0,sigma);
pom(gau==Inf)=1;
gau(gau==Inf)=0;
% gau(gau>100)=0;

% imshow(gau,[])

mix=-a-vaha*gau;

mix=imimposemin(mix,rosekana_er_old);
rosekana=(maska>0).*(watershed(mix)>0);
% imshow(rosekana,[])
