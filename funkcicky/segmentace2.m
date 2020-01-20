function [mu_new,sigma_new,p_new,zabit_new,nenalezen_new,maska_jadra,pouzite_new]=segmentace2(qpi,dapi,mu,sigma,p,zabit,nenalezen,pouzite)

% puntiky=centroid2mask_l(mu, size(qpi));
% puntiky=centroid2mask(mu, size(qpi));
% puntiky_mimo=puntiky.*

% maska=zeros(100);
% maska(1:50,1:50)=1;
% mu=[60,40];
vydrz=3;
nahnute=3;

mu(mu==0)=300;

maska=segmentace_popredi_dapi2(dapi);
puntiky_hodnoty=maska(sub2ind(size(maska),mu(find(pouzite),1),mu(find(pouzite),2)))==0;

if sum(sum(puntiky_hodnoty==0))>0
    %     cisla_mimo=unique(puntiky_mimo
    pom=find(puntiky_hodnoty==0);
    %     puntiky=mu(find(puntiky_hodnoty==0),:);
    %     mu(,:)=[];
    
    %     zab=zabit;
    %     zab(find(puntiky_hodnoty==0))=[];
    [x,y]=meshgrid(1:size(maska,1),1:size(maska,2));
    x=x(maska>0);
    y=y(maska>0);
    x=x(:);
    y=y(:);
    zab=[];
    for k=pom'
        
        [nejmin,ktery]=min((x-mu(k,1)).^2+(y-mu(k,2)).^2);
        if (zabit(k)<1)&&nejmin<50
            mu(k,:)=[x(ktery),y(ktery)];
            
        else
            
            zab=[zab,k];
        end
        
    end
    %     mu(zab,:)=[];
    %     sigma(:,:,zab)=[];
    %     p(zab)=[];
    %     zabit(zab)=[];
    pouzite(zab)=0;
    
end

% zabit_zal=zabit;
% pouzite_zal
% mu__zal
% sigma_zal
% p_zal


zabit_new=zabit;
nenalezen_new=nenalezen;
pouzite_new=pouzite;
mu_new=mu;
sigma_new=sigma;
p_new=p;




pouzivam=zeros(size(p_new));


puntiky=centroid2mask_l(mu, size(qpi));
puntiky_pom=centroid2mask(mu(find(pouzite_new),:), size(qpi));
puntiky=puntiky.*puntiky_pom;

% mu_new=[];
% sigma_new=[];
% p_new=[];


maska_jadra=zeros(size(maska));
pouzite=maska;

vysledek=[];
[x,y]=meshgrid(1:size(maska,1),1:size(maska,2));
l=bwlabel(maska);
ml=max(l(:));
for k=1:ml
    bunka=l==k;
    kolik=sum(sum((bunka.*puntiky)>0));
    %     if kolik==1
    %         cent=regionprops(bunka,'Centroid');
    %         vysledek=[vysledek;[cent.Centroid]];
    %     end
    if kolik>=1
        maska_jadra(bunka)=1;
        maska(bunka)=0;
        
        pozice_stara=bunka.*puntiky;
        ktere=unique(pozice_stara);
        ktere(ktere==0)=[];
        pozice_stara=pozice_stara>0;
        
        
        
        %         dapi_p=500*dapi;
        x_inint=x(pozice_stara==1);
        y_inint=y(pozice_stara==1);
        %         I_inint=dapi_p(pozice_stara==1);
        %         grayslice()
        xx=x(bunka);
        yy=y(bunka);
        I=dapi(bunka);
        II=grayslice(I,40);
        X=[];
        for q=1:length(xx)
            X=[X;repmat([xx(q),yy(q)],[II(q),1])];
        end
        %         X=[xx(:),yy(:)];
        
        
        %        [idx,C]  = kmeans(X,kolik,'Start',[x_inint(:),y_inint(:)]);
        %         [idx,C]  = kmeans(X,kolik,'Start',[x_inint(:),y_inint(:)]);
        %         GMModel=gmdistribution([x_inint(:),y_inint(:)],eye(2));
        %         S.mu=mu(ktere,:);
        %         S.Sigma=repmat(eye(2),[1 1 kolik]);
        %         S.ComponentProportion=ones(1,kolik);
        S.mu=mu(ktere,:);
        S.Sigma=sigma(:,:,ktere);
        S.ComponentProportion=p(ktere);
        
        
        
        
        
        try
            GMModel = fitgmdist(X,kolik,'Start',S);

        catch 
            GMModel = fitgmdist(X,kolik,'Start',S,'RegularizationValue',0.1);
            disp('There was an error fitting the Gaussian mixture model')
        end
        
        
        
        
        %         C=GMModel.mu;
        %         vysledek=[vysledek;C];
        %         D=bwdistgeodesic()
        %         X=[xx(:),yy(:),I(:)];
        %        [idx,C]  = kmeans(X,kolik,'Start',[x_inint(:),y_inint(:),I_inint(:)]);
        %         options.weight=I(:);
        %        [idx,C, dis] = fkmeans(X, kolik,options);
        %
        %        imshow(bunka,[]);
        %        hold on
        %        plot(x_inint(:),y_inint(:),'b*')
        %        plot(C(:,1),C(:,2),'r*')
        
        mu_new(ktere,:)=round(GMModel.mu);
        sigma_new(:,:,ktere)=GMModel.Sigma;
        p_new(ktere)=GMModel.ComponentProportion;
        pouzivam(ktere)=1;
    end
end
zabit_new=zabit_new-1;
% pouzite_new=pouzite_new&pouzivam;
nenalezen_new(pouzivam>0)=vydrz+1;
nenalezen_new=nenalezen_new-1;
pouzite_new=(pouzite_new&pouzivam)|(pouzite_new&(nenalezen>0));

if(sum(sum(maska)))>0
    l=bwlabel(maska);
    ml=max(l(:));
    for k=1:ml
        b=l==k;
        pom=regionprops(b>0,'centroid');
        init_body=cat(1,pom.Centroid);
        
        mu_new=[mu_new;round(init_body)];
        sigma_new=cat(3,sigma_new,3*eye(2));
        p_new=[p_new,1];
        zabit_new=[zabit_new,nahnute];
        pouzite_new=[pouzite_new,1];
        nenalezen_new=[nenalezen_new,0];
    end
    
    
end





% x = [randn(4000,1)/2; 5+2*randn(6000,1)];
%
% f = fitgmdist(x,2);
%
% histogram(x,'Normalization','pdf')
% xgrid = linspace(-4,12,1001)';
% hold on; plot(xgrid,pdf(f,xgrid),'r-'); hold off