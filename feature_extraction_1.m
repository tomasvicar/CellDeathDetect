%Composed by Tomas Vicar 15/03/2019, 
% Department of Biomedical Engineering, Brno University of Technology  
% vicar@feec.vutbr.cz


clc;clear all;close all;
addpath('utils')
mkdir('tmp')

data_folder='..\preulozene_na_poslani\';%set the data folder


listing=subdir([data_folder '*.xlsx']);
listing={listing(:).name};

for name=listing
    name{1}
    name_table=name{1};
    name_tmp=name{1}(1:end-5);
    name_mask=[strrep(name_tmp,'labels_','mask_') '.tif'];
    name_qpi=[strrep(name_tmp,'labels_','QPI_') '.tif'];
    name_features=[strrep(strrep(name_tmp,'labels_','features_'),data_folder,'tmp\') '.mat'];
    
    T=readtable(name_table);
    
    
    features=[];

            
    info=imfinfo(name_qpi);
    
    for t=1:length(info)
        t
        
        CDS=[];
        Histogram_max=[];
        Histogram_max_pos=[];
        Histogram_entropy=[];
        
         
        qpi=imread(name_qpi,t);
        mask=imread(name_mask,t);
        

        props=regionprops(mask,qpi,'Area','MeanIntensity','Perimeter','Eccentricity','Centroid','WeightedCentroid');
        
        A=cat(1,props.Area);
        A(A==0)=nan;
        Density=cat(1,props.MeanIntensity);
        P=cat(1,props.Perimeter);
        Eccentricity=cat(1,props.Eccentricity);
        C=cat(1,props.Centroid);
        WC=cat(1,props.WeightedCentroid); 
        
        
        if t==1
            qpi_old=qpi;
            mask_old=mask;
            C_old=C;
            WC_old=WC;
        end
        
        
        
        Area=A/2.5464;%2.5464 px^2  = um^2
        Mass=(Density.*A)/2.5464;
        Circularity=4*pi*A./(P.^2);
        
        
        ml=max(mask(:));
        for k=1:ml
            if sum(sum(mask==k))~=0
                CDS(k)=sqrt(sum(sum((qpi_old(mask==k)-qpi(mask==k)).^2)));
            else
                CDS(k)=nan;
            end
        end
        CDS=CDS'./Area;
        
        
        for k=1:ml
            hist=imhist(qpi(mask==k));
            hist=conv2(hist,[1 1 1 1 1]', 'valid');%smooth historam
            if ~isempty(hist)
                [m,i]=max(hist);
                p = hist / sum(hist);
                p(p==0)=eps;
                e=-sum(p .*log(p));
            else
                m=nan;
                i=nan;
                e=nan;
            end
            Histogram_max(k)=m;
            Histogram_max_pos(k)=i;
            Histogram_entropy(k)=e;
        end
        
        
        Speed=sqrt((C(:,1)-C_old(:,1)).^2+(C(:,2)-C_old(:,2)).^2);
        Weighted_speed =sqrt((WC(:,1)-WC_old(:,1)).^2+(WC(:,2)-WC_old(:,2)).^2);
        
        
        
                
        for k=1:ml
            features(k).Mass(t)=Mass(k);
            features(k).Area(t)=Area(k);
            features(k).Density(t)=Density(k);
            features(k).Circularity(t)=Circularity(k);
            features(k).Eccentricity(t)=Eccentricity(k);
            features(k).CDS(t)=CDS(k);
            features(k).Histogram_max(t)=Histogram_max(k);
            features(k).Histogram_max_pos(t)=Histogram_max_pos(k);
            features(k).Histogram_entropy(t)=Histogram_entropy(k);
            features(k).Speed(t)=Speed(k);
            features(k).Weighted_spee(t)=Weighted_speed(k);
        end
       
        

        
        
        qpi_old=qpi;
        mask_old=mask;
        C_old=C;
        WC_old=WC;
    end
    
    
    
    save(name_features,'features')
    
end