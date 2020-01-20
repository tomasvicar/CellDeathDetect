clc;clear all;close all;
addpath('funkcicky')


% co={'../skluzavky_dataset_pouzita_data/DU145_st'};
% co={'../skluzavky_dataset_pouzita_data/DU145_do'};
% co={'../skluzavky_dataset_pouzita_data/DU145_Fluo'};

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
    
    for pole=1:7
        citac=citac+1;
        info=imfinfo([c{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff']);
%         info=info(10:end-10);
%         info=info(end-10:end);
        
        clear amplituda dapi qpi tritc fitc smichany dapi_log
        citacek=0;
        for k=length(info)-105:length(info)-5
%         for k=10:length(info)-5
            citacek=citacek+1;
            
            %             amplituda=imread([c{1} '/' 'Amplitude-00' num2str(pole) '-001.tiff'],k);
            dapi_pom=imread([c{1} '/' 'Clipped-DAPI-00' num2str(pole) '-001.tiff'],k);
            qpi_pom=imread([c{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff'],k);
            
            a=qpi_pom;
            a=medfilt2(a,[3 3]); %uz sou predulozeny !!!!!! opravit
            a=imgaussfilt(a,0.5);
            qpi_pom=mat2gray(a,[-0.1 2]);
            
            
            b=dapi_pom;
            b=medfilt2(b,[3 3]);
            b=imgaussfilt(b,0.5);
            dapi_pom=mat2gray(b,[0 1000]);
            
            
            dapi(:,:,citacek)=dapi_pom;
            
%             for kk=10
%                 h = fspecial('log',[100 100],kk);
%                 pomm(:,:,kk)=conv2_spec(dapi_pom,-h);
%             end
%             dapi_log(:,:,k)=max(pomm,[],3);
            
            qpi(:,:,citacek)=qpi_pom;
            
%             imshow(dapi_log(:,:,k),[])
            
            smichany_pom=cat(3,qpi_pom,qpi_pom,qpi_pom);
            
            
            smichany_pom(:,:,3)=smichany_pom(:,:,3)+mat2gray(dapi_pom,[0.1 0.5]);

            smichany(:,:,citacek,:)=uint8(smichany_pom*255);
        end
        

        smichany=smichany(:,:,end:-1:1,:);
%         dapi_log=dapi_log(:,:,end:-1:1);
        dapi=dapi(:,:,end:-1:1);
        qpi=qpi(:,:,end:-1:1);
        
        [teckyy,masky_jadraa]=detekce(qpi(:,:,1),dapi(:,:,1));
        pom=regionprops(teckyy>0,'centroid');
        init_body=cat(1,pom.Centroid);
        init_body=inicializace_a_deleni(smichany,init_body);

        save([c{1} '/' num2str(pole) 'inicial.mat'],'init_body')
        
        
%      
        
    end
end