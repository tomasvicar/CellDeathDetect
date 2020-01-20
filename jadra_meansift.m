clc;clear all;close all;
addpath('funkcicky')

% co={'../skluzavky_dataset_pouzita_data/DU145_Fluo','../skluzavky_dataset_pouzita_data/LNCaP_st','../skluzavky_dataset_pouzita_data/LNCaP_do','../skluzavky_dataset_pouzita_data/LNCaP_Fluo','../skluzavky_dataset_pouzita_data/PNT1A_st','../skluzavky_dataset_pouzita_data/PNT1A_do','../skluzavky_dataset_pouzita_data/PNT1A_Fluo'};

% co={'../skluzavky_dataset_pouzita_data/LNCaP_Fluo'};

% co={'../skluzavky_dataset_pouzita_data/DU145_st','../skluzavky_dataset_pouzita_data/DU145_do','../skluzavky_dataset_pouzita_data/DU145_Fluo'};

% co={'../skluzavky_dataset_pouzita_data/LNCaP_st'};
% co={'../skluzavky_dataset_pouzita_data/LNCaP_do'};
% co={'../skluzavky_dataset_pouzita_data/LNCaP_Fluo'};

% co={'../skluzavky_dataset_pouzita_data/PNT1A_st'};
% co={'../skluzavky_dataset_pouzita_data/PNT1A_do'};
% co={'../skluzavky_dataset_pouzita_data/PNT1A_Fluo'};

co={'../2019-11-15_12-48-14_experiment_cast'};


citac=0;
for c=co
    cc=c{1};
    cc=cc(4:end);
    
    for pole=1:4
        citac=citac+1;
        info=imfinfo([c{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff']);
%         info=info(10:end-10);
%         info=info(end-10:end);
        
        clear amplituda dapi qpi tritc fitc smichany dapi_log
        
        dapi=zeros([600 600 length(10:length(info)-5)]);
        qpi=zeros([600 600 length(10:length(info)-5)]);
        smichany=uint8(zeros([600 600 length(10:length(info)-5) 3]));

%         dapi=zeros([600 600 length(length(info)-20:length(info)-5)]);
%         qpi=zeros([600 600 length(length(info)-20:length(info)-5)]);
%         smichany=uint8(zeros([600 600 length(length(info)-20:length(info)-5) 3]));

        fg_dapi=uint8(zeros([600 600 length(10:length(info)-5)]));
        fg_qpi=uint8(zeros([600 600 length(10:length(info)-5)]));
        
        citacek=0;
%         for k=length(info)-20:length(info)-5
        for k=10:length(info)-5
            citacek=citacek+1;
            disp(['read ' num2str(citacek)]);
            
            %             amplituda=imread([c{1} '/' 'Amplitude-00' num2str(pole) '-001.tiff'],k);
            dapi_pom=imread([c{1} '/' 'f_Clipped-DAPI-00' num2str(pole) '-001.tiff'],k);
            qpi_pom=imread([c{1} '/' 'f_Compensated phase-pgpum2-00' num2str(pole) '-001.tiff'],k);
            smichany_pom=imread([c{1} '/' 'f_qpi_dapi-00' num2str(pole) '-001.tiff'],k);
            fg_dapi_tmp=imread([c{1} '/' 'f_foreground_dapi-00' num2str(pole) '-001.tiff'],k);
            fg_qpi_tmp=imread([c{1} '/' 'f_foreground_qpi-00' num2str(pole) '-001.tiff'],k);
            
            dapi(:,:,citacek)=dapi_pom;
            

            qpi(:,:,citacek)=qpi_pom;
            

            smichany(:,:,citacek,:)=smichany_pom;
            
            fg_dapi(:,:,citacek)=fg_dapi_tmp;
            fg_qpi(:,:,citacek)=fg_qpi_tmp;
            
        end
        

        smichany=smichany(:,:,end:-1:1,:);
        dapi=dapi(:,:,end:-1:1);
        qpi=qpi(:,:,end:-1:1);
        
        [teckyy,masky_jadraa]=detekce(qpi(:,:,1),dapi(:,:,1));
        pom=regionprops(teckyy>0,'centroid');
        init_body=cat(1,pom.Centroid);
               
        
        load([c{1} '/' num2str(pole) 'inicial.mat'])
        
        

%         GMModel=gmdistribution(mu,sigma,p);
        mu=init_body;
        sigma=repmat(3*eye(2),[1 1 size(init_body,1)]);
        p=ones(1,size(init_body,1));
        zabit=zeros(1,size(init_body,1));
        pouzite=ones(1,size(init_body,1));
        nenalezen=ones(1,size(init_body,1));

        vysledky=[];
        puntiky_old=init_body;
        for k=1:size(qpi,3)
            k
%             tic
            [mu_new,sigma_new,p_new,zabit_new,nenalezen_new,maska_jadra,pouzite_new]=segmentace2(qpi(:,:,k),dapi(:,:,k),mu,sigma,p,zabit,nenalezen,pouzite);
%             toc

            
            puntiky_old=mu;
            puntiky_new=mu_new;
            
           imshow(squeeze(smichany(:,:,k,:)),[]);
%            imshow(qpi(:,:,k),[]);
           hold on 
           plot(puntiky_old(find(pouzite),1),puntiky_old(find(pouzite),2),'b*')
           plot(puntiky_new(find(pouzite),1),puntiky_new(find(pouzite),2),'r*')
           title(num2str(k))
           hold off
           drawnow;
%            mkdir('vys')
%            mkdir(['vys/' cc])
           
           mkdir(['pom/' cc '/' num2str(pole)])
           print(['pom/' cc '/' num2str(pole) '/' num2str(k)],'-dpng')
            
%             puntiky_old=puntiky_new;
            mu=mu_new;
            sigma=sigma_new;
            p=p_new;
            zabit=zabit_new;
            nenalezen=nenalezen_new;
            pouzite=pouzite_new;
            
            vysledky(k).mu=mu;
            vysledky(k).sigma=sigma;
            vysledky(k).p=p;
            vysledky(k).zabit=zabit;
            vysledky(k).nenalezen=nenalezen;
            vysledky(k).pouzite=pouzite;
            vysledky(k).maska_jadra=maska_jadra>0;
            
        end
        save([c{1} '/' num2str(pole) 'detekce_gmm.mat'],'vysledky','-v7.3')
        pause(30)
%         centroidy=[centroidy;C];
        
    end
end