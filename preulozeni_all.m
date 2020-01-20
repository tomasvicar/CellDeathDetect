clc;clear all;close all;
addpath('funkcicky')



% co={'../skluzavky_dataset_pouzita_data/DU145_st','../skluzavky_dataset_pouzita_data/DU145_do','../skluzavky_dataset_pouzita_data/PNT1A_st'};

% co={'../skluzavky_dataset_pouzita_data/DU145_do'};

% co={'../skluzavky_dataset_pouzita_data/DU145_st','../skluzavky_dataset_pouzita_data/DU145_do','../skluzavky_dataset_pouzita_data/DU145_Fluo','../skluzavky_dataset_pouzita_data/LNCaP_st','../skluzavky_dataset_pouzita_data/LNCaP_do','../skluzavky_dataset_pouzita_data/LNCaP_Fluo','../skluzavky_dataset_pouzita_data/PNT1A_st','../skluzavky_dataset_pouzita_data/PNT1A_do','../skluzavky_dataset_pouzita_data/PNT1A_Fluo'};

% co={'../2019-11-15_12-48-14_experiment'};

co={'Z:\CELL_MUNI\tmp\sluzavky_dodelani_experimentu\Tif_DU145_z-VAD-fmk_inhibitor'};


citac=0;
for c=co
    cc=c{1};
    cc=cc(4:end);
    
    for pole=1:4
        citac=citac+1;
        pole
        
        
        clear amplituda dapi qpi tritc fitc smichany dapi_log
        citacek=0;
        
        %         for dodatek={'_zacatek','-pokracovani'}
        dodatek={''};
        
%         info=imfinfo([c{1} dodatek{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff']);
        %         info=info(10:end-10);
        %         info=info(end-10:end);
        
        
        %         for k=length(info)-20:length(info)-5
        for k=1:600
            citacek=citacek+1;
            citacek
            
% % % % %                           amplituda=imread([c{1} dodatek{1} '/' 'Amplitude-00' num2str(pole) '-001-' num2str(k,'%03.f') '.tiff']);
            dapi_pom=single(imread([c{1} dodatek{1} '/' 'Clipped-DAPI-00' num2str(pole) '-001.tiff'],k));
            qpi_pom=imread([c{1} dodatek{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff'],k);
            tritc_p=single(imread([c{1} dodatek{1} '/' 'Clipped-TRITC-00' num2str(pole) '-001.tiff'],k));%cervena - po smrti bunky
            fitc_p=single(imread([c{1} dodatek{1} '/' 'Clipped-FITC-00' num2str(pole) '-001.tiff'],k)); %zelena - aktivace kaspaz
            
            
            c_pom='Z:\CELL_MUNI\tmp\sluzavky_dodelani_experimentu\Tif_DU145_z-VAD-fmk_inhibitor_resave';
            
            tiff_stack([c_pom dodatek{1} '/' 'Clipped-DAPI-00' num2str(pole) '-001.tiff'],dapi_pom,k)
            tiff_stack([c_pom dodatek{1} '/' 'Compensated phase-pgpum2-00' num2str(pole) '-001.tiff'],qpi_pom,k)
            tiff_stack([c_pom dodatek{1} '/' 'Clipped-TRITC-00' num2str(pole) '-001.tiff'],tritc_p,k)
            tiff_stack([c_pom dodatek{1} '/' 'Clipped-FITC-00' num2str(pole) '-001.tiff'],fitc_p,k)
            
            
            
            a=qpi_pom;
            a=medfilt2(a,[3 3]);
            a=imgaussfilt(a,0.5);
            qpi_pom=mat2gray(a,[-0.1 2]);
            
            
            dapi_pom_norm=(dapi_pom-mean(dapi_pom(:)))/std(dapi_pom(:));
            
            b=dapi_pom;
            b=medfilt2(b,[3 3]);
            b=imgaussfilt(b,0.5);
            dapi_pom=mat2gray(b,[0 1000]);
            
            
            
            smichany_pom=cat(3,qpi_pom,qpi_pom,qpi_pom);
            
            
            smichany_pom(:,:,3)=smichany_pom(:,:,3)+mat2gray(dapi_pom,[0.1 0.45]);
            
            smichany=uint8(smichany_pom*255);
            
            
            
            tritc_p=(tritc_p-mean(tritc_p(:)))/std(tritc_p(:));
            
            fitc_p=(fitc_p-mean(fitc_p(:)))/std(fitc_p(:));
            
            
            maska_qpi=segmentace_popredi(qpi_pom);
            maska_dapi=segmentace_popredi_dapi(dapi_pom);
            
%                         tiff_stack([c{1} '/' 'f_Amplitude-00' num2str(pole) '-001.tiff'],amplituda,citacek)
            tiff_stack([c_pom '/' 'f_Clipped-DAPI-00' num2str(pole) '-001.tiff'],dapi_pom,citacek)
            tiff_stack([c_pom '/' 'f_norm_Clipped-DAPI-00' num2str(pole) '-001.tiff'],dapi_pom_norm,citacek)
            
            tiff_stack([c_pom '/' 'f_Compens