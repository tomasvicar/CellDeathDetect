function [jadra_vys,bunky_vys]=segm_podle_gmm(qpi,dapi,vysledky,maska_old)

maska_jadra=vysledky.maska_jadra>0;
maska=segmentace_popredi(qpi);
maska=maska|maska_jadra;


mu=vysledky.mu;
sigma=vysledky.sigma;
p=vysledky.p;

pouzit=vysledky.pouzite;

mu=mu(find(pouzit),:);
sigma=sigma(:,:,find(pouzit));
p=p(find(pouzit));

obj = gmdistribution(mu,sigma,p);

[x,y]=meshgrid(1:size(maska,1),1:size(maska,2));
xx=x(maska_jadra);
yy=y(maska_jadra);
xx=xx(:);
yy=yy(:);

idx = cluster(obj,[xx,yy]);

maska_jadra=double(maska_jadra);
maska_jadra(maska_jadra==1)=idx;

prazdne=zeros(size(maska_jadra));
pom=find(pouzit);
ml=max(maska_jadra(:));
for k=1:ml
    b=maska_jadra==k;
    prazdne(b)=pom(k);
end
% idx=prazdne;
jadra_vys=prazdne;
% drawnow;




% sigma=4;
% vaha=0.5;
kolik_erodovat=5;





% l=bwlabel(maska);

pozadi_er_old=~imdilate(maska_old,strel('disk',kolik_erodovat));

popredi_er_old=imerode(maska_old,strel('disk',kolik_erodovat));




rosekana_old=maska_jadra;
BW = boundarymask(maska_jadra);
rosekana_old(BW)=0;
rosekana_old=rosekana_old>0;

cent=regionprops(rosekana_old>0,'Centroid');
cent=round(cat(1,cent.Centroid));

rosekana_er_old=imerode(rosekana_old,strel('disk',kolik_erodovat));
rosekana_er_old=double(rosekana_er_old);
% rosekana_er_old(sub2ind(size(maska),cent(:,2),cent(:,1)))=rosekana_er_old(sub2ind(size(maska),cent(:,2),cent(:,1)))+1;
rosekana_er_old(sub2ind(size(maska),cent(:,2),cent(:,1)))=1;

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



D = bwdistgeodesic(maska>0,rosekana_er_old>0,'quasi-euclidean');
D=D;
D(maska==0)=99999999;
hranice=(watershed(D)==0).*(maska>0);


pom=zeros(size(D));

D = bwdistgeodesic(maska>0,hranice>0,'quasi-euclidean');
D=D>kolik_erodovat;
% D(D==Inf)=0;
% gau=exp(D.^2./(2*sigma^2));
% gau=pdf('norm',D,0,sigma);
% pom(gau==Inf)=1;
% gau(gau==Inf)=0;
% gau(gau>100)=0;

% imshow(gau,[])

mix=-qpi-100*D;

mix=imimposemin(mix,rosekana_er_old);

pom=maska>0;
pom=pom|popredi_er_old;
rosekana=(pom).*(watershed(mix)>0);
rosekana(pozadi_er_old)=0;


% imshow(rosekana,[]);
% drawnow;

bunky_vys=zeros(size(rosekana));
l=bwlabel(rosekana);
ml=unique(jadra_vys);
for k=ml'
    
    b=jadra_vys==k;
    bb=l(b);
    bb(bb==0)=[];
    bb=mode(bb(:));
    pom=l==bb;
    pomm=imfill(pom,'holes');
    if sum(sum(rosekana(pomm&(~pom))))==0
        pom=pomm;
    end
    bunky_vys(pom)=k;
end






