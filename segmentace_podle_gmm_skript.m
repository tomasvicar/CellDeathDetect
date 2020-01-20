clc;clear all;close all;
addpath('funkcicky')

% co={'../skluzavky_dataset_pouzita_data/DU145_st'};

% co={'../skluzavky_dataset_pouzita_data/LNCaP_st','../skluzavky_dataset_pouzita_data/LNCaP_do'};
% co={'../skluzavky_dataset_pouzita_data/PNT1A_st','../skluzavky_dataset_pouzita_data/PNT1A_do','../skluzavky_dataset_pouzita_data/PNT1A_Fluo'};

% co={'../skluzavky_dataset_pouzita_data/LNCaP_Fluo'};
co={'../2019-11-15_12-48-14_experiment_cast'};

citac=0;
for c=co
    cc=c{1};
    cc=cc(4:end);
    
    for pole=1:7
        citac=citac+1;
        info=imfinfo([c{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff']);
%         info=info(10:end-10);
%         info=info(end-10:end);
        
        clear amplituda dapi qpi tritc fitc smichany dapi_log vysledky
        
        dapi=zeros([600 600 length(10:length(info)-5)]);
        qpi=zeros([600 600 length(10:length(info)-5)]);
        smichany=uint8(zeros([600 600 length(10:length(info)-5) 3]));
        
        citacek=0;
%         for k=length(info)-20:length(info)-5
        for k=10:length(info)-5
            citacek=citacek+1;
            disp(['read   '  num2str(citacek)])
            %             amplituda=imread([c{1} '/' 'Amplitude-00' num2str(pole) '-001.tiff'],k);
%             dapi_pom=imread([c{1} '/' 'Clipped-DAPI-00' num2str(pole) '-001.tiff'],k);
%             qpi_pom=imread([c{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff'],k);
            
            dapi_pom=imread([c{1} '/' 'f_Clipped-DAPI-00' num2str(pole) '-001.tiff'],k);
            qpi_pom=imread([c{1} '/' 'f_Compensated phase-pgpum2-00' num2str(pole) '-001.tiff'],k);
            smichany_pom=imread([c{1} '/' 'f_qpi_dapi-00' num2str(pole) '-001.tiff'],k);
            

            
            dapi(:,:,citacek)=dapi_pom;
            

            qpi(:,:,citacek)=qpi_pom;
            

            smichany(:,:,citacek,:)=smichany_pom;
        end
        

        smichany=smichany(:,:,end:-1:1,:);
%         dapi_log=dapi_log(:,:,end:-1:1);
        dapi=dapi(:,:,end:-1:1);
        qpi=qpi(:,:,end:-1:1);
        
        
        
        
        
%                             vysledky(k).mu=mu;
%             vysledky(k).sigma=sigma;
%             vysledky(k).p=p;
%             vysledky(k).zabit=zabit;
%             vysledky(k).pouzite=pouzite;
%             vysledky(k).maska_jadra=maska_jadra;
        
        load([c{1} '/' num2str(pole) 'detekce_gmm.mat'])
        vys_old=vysledky;
        
        
        pom=[];
        for k=1:length(vysledky)
            pom(1:length(vysledky(k).pouzite),k)=vysledky(k).pouzite;
        end
        pom=sum(pom,2)>10;
        
        for k=1:length(vysledky)
            pom2=vysledky(k).pouzite;
            pom2=pom2.*pom(1:length(pom2))';
            vysledky(k).pouzite=pom2;
        end
        
        
        
        segmentace_jadra=zeros([600 600 length(10:length(info)-5)]);
        segmentace_bunky=zeros([600 600 length(10:length(info)-5)]);
        
        
        maska_old=segmentace_popredi(qpi(:,:,1));
        
        
        
        for k=1:size(qpi,3)
            k
            [jadra,bunky]=segm_podle_gmm(qpi(:,:,k),dapi(:,:,k),vysledky(k),maska_old);
            maska_old=bunky>0;
            segmentace_jadra(:,:,k)=jadra;
            segmentace_bunky(:,:,k)=bunky;
            
            
           imshow(squeeze(smichany(:,:,k,:)),[]);
           hold on 
           pom=jadra;
           bw = boundarymask(pom);
           pom(bw)=0;
           visboundaries(pom>0,'Color','r','LineWidth',0.5,'EnhanceVisibility',false)
           visboundaries(bunky>0,'Color','b','LineWidth',0.5,'EnhanceVisibility',false)
           title(num2str(k))
           pom=regionprops(jadra,'centroid');
           body=cat(1,pom.Centroid);
           textik=cellfun(@num2str,num2cell([1:size(body,1)]),'UniformOutput',false);
           text(body(:,1),body(:,2),textik);
           drawnow;
           hold off
           mkdir(['pom3/' cc '/' num2str(pole)])
           print(['pom3/' cc '/' num2str(pole) '/' num2str(k)],'-dpng')
            
            
        end
        save([c{1} '/' num2str(pole) 'masky_segmentace.mat'],'segmentace_jadra','segmentace_bunky','-v7.3')
        drawnow;
        pause(30)
    end
end