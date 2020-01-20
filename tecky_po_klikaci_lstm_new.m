clc;clear all;close all force;
addpath('funkcicky')


%%%%%%area dìl 2.5464^2


% co={'../skluzavky_dataset_pouzita_data/DU145_st','../skluzavky_dataset_pouzita_data/DU145_do','../skluzavky_dataset_pouzita_data/DU145_Fluo','../skluzavky_dataset_pouzita_data/LNCaP_st','../skluzavky_dataset_pouzita_data/LNCaP_do','../skluzavky_dataset_pouzita_data/LNCaP_Fluo','../skluzavky_dataset_pouzita_data/PNT1A_st','../skluzavky_dataset_pouzita_data/PNT1A_do','../skluzavky_dataset_pouzita_data/PNT1A_Fluo'};


co={'../2019-11-15_12-48-14_experiment_cast'};



citac=0;
citac_slozky=0;
for c=co
    cc=c{1};
    cc=cc(4:end);
    citac_slozky=citac_slozky+1;
    
    slozka_name=strsplit(cc,'/');
    slozka_name=slozka_name{end};
    
    
    
    citac_bunek_all=0;
    
    
    for pole=1:7
        pole
        shluciky.euk{citac_slozky,pole}=[];
        shluciky.density{citac_slozky,pole}=[];
        
        shluciky.euk_norm1{citac_slozky,pole}=[];
        shluciky.density_norm1{citac_slozky,pole}=[];
       
        shluciky.euk_norm2{citac_slozky,pole}=[];
        shluciky.density_norm2{citac_slozky,pole}=[];
        
        shluciky.cisla{citac_slozky,pole}=[];
        shluciky.cer{citac_slozky,pole}=[];
        shluciky.zel{citac_slozky,pole}=[];
        shluciky.mod_j{citac_slozky,pole}=[];
        shluciky.propca{citac_slozky,pole}=[];
        
        shluciky.propca_norm1{citac_slozky,pole}=[];
        shluciky.propca_norm2{citac_slozky,pole}=[];
        
        shluciky.typ_smrti{citac_slozky,pole}=[];
        shluciky.barva_spozdeni{citac_slozky,pole}=[];
        shluciky.area_j{citac_slozky,pole}=[];
        shluciky.density_j{citac_slozky,pole}=[];
        
        citac=citac+1;
        clear parametry typ_smrti pozice_smrti cislo_bunky_klikac

        load([c{1} '/' num2str(pole) 'parametry_jadra2_kor_cer.mat'])
        load(['ukladacka_pole' num2str(pole) '.mat'])
        
        
        okra=cat(1,parametry.okraj);
        obvo=cat(1,parametry.obvod);
        p_okra=okra./obvo;
        pouzite2=sum(p_okra>0.1,2)>0.1*size(p_okra,2);
        
        pouzite=cat(1,parametry.area_b);
        pouzite=sum(~isnan(pouzite),2)>0.8*size(pouzite,2);
        pouzite=pouzite&(~pouzite2);
        
        pouzite=find(pouzite);
        
        
        
        %         midle_point=round(size(okra,2)/2);
        
        
        cit=0;
        for k=1:1:length(pouzite)
            citac_bunek_all=citac_bunek_all+1;
            
            k_cila_poradi=k;
            k0=k;
            cislo=pouzite(k);
            pozadi=k;
            
            
            circularity0=parametry(cislo).circularity;
            rychlost0=parametry(cislo).rychlost;
            Weightedrychlost0=parametry(cislo).Weightedrychlost;
            Eccentricity0=parametry(cislo).Eccentricity;
            area0=parametry(cislo).area_b/(2.5464^2);
            cer_j0=parametry(cislo).cer_j;
            mod_j0=parametry(cislo).mod_j;
            zel_j0=parametry(cislo).zel_j;
            mass0=parametry(cislo).mass;
            density0=parametry(cislo).density;
            bin_zmena0=parametry(cislo).bin_zmena;
            area_j0=parametry(cislo).area_j/(2.5464^2);
            density_j0=parametry(cislo).density_j;
            
            euk0=parametry(cislo).euk;
            euk0(1)=euk0(2);
            euk0=(euk0)./(area0*2.5464);
            
            
%             jak=typ_smrti(cislo);
            kdy=ukladacka_pole(k);
            
            if kdy<0
                continue
            end
            
            
            
            
            
            euk=imgaussfilt(medfilt1(euk0,10,'truncate'),5,'Padding','symmetric');
            cer=imgaussfilt(medfilt1(cer_j0,10,'truncate'),5,'Padding','symmetric');
            zel=imgaussfilt(medfilt1(zel_j0,10,'truncate'),5,'Padding','symmetric');
            mod=imgaussfilt(medfilt1(mod_j0,10,'truncate'),5,'Padding','symmetric');
            mass=imgaussfilt(medfilt1(mass0,10,'truncate'),5,'Padding','symmetric');
            area=imgaussfilt(medfilt1(area0,10,'truncate'),5,'Padding','symmetric');
            Eccentricity=imgaussfilt(medfilt1(Eccentricity0,10,'truncate'),5,'Padding','symmetric');
            Weightedrychlost=imgaussfilt(medfilt1(Weightedrychlost0,10,'truncate'),5,'Padding','symmetric');
            rychlost=imgaussfilt(medfilt1(rychlost0,10,'truncate'),5,'Padding','symmetric');
            circularity=imgaussfilt(medfilt1(circularity0,10,'truncate'),5,'Padding','symmetric');
            bin_zmena=imgaussfilt(medfilt1(bin_zmena0,10,'truncate'),5,'Padding','symmetric');
            density=imgaussfilt(medfilt1(density0,10,'truncate'),5,'Padding','symmetric');
            area_j=imgaussfilt(medfilt1(area_j0,10,'truncate'),5,'Padding','symmetric');
            density_j=imgaussfilt(medfilt1(density_j0,10,'truncate'),5,'Padding','symmetric');
            
            histik=parametry(cislo).hist;
            histik=conv2(histik,[1 1 1 1 1], 'valid');
            
%             
%             close all
%             plot(mat2gray(mass),'r')
%             hold on
%             plot(mat2gray(euk),'b')
%             plot(kdy,0.5,'*')
%             drawnow
%             pause(1)
            
            clear maxhist maxhist_p entropycka
            for k_pom=1:size(histik,1)
                histik_pom=histik(k_pom,:);
                [maxhistx,maxhist_px]=max(histik_pom);
                maxhist(k_pom)=maxhistx;
                maxhist_p(k_pom)=maxhist_px;
                p = histik_pom / sum(histik_pom);
                p(p==0)=1;
                entropycka(k_pom) = -sum(p .*log(p));
            end
            
            
            propca=[mass;area;euk;density;Weightedrychlost;rychlost;Eccentricity;circularity;bin_zmena;maxhist;maxhist_p;entropycka];
                
            if 1%jak<3
                okno=200;
%                 okno=100;
                ind=kdy-(okno-1):kdy;
                ind(ind<=0)=[];
                ind(ind>length(mass))=[];
                
                ind2=kdy:kdy+(okno-1);
                ind2(ind2>length(mass))=[];
                

                shluciky.euk{citac_slozky,pole}=[shluciky.euk{citac_slozky,pole} nanmean(euk(ind))];
                shluciky.density{citac_slozky,pole}=[shluciky.density{citac_slozky,pole} nanmean(density(ind))];
                
                shluciky.euk_norm1{citac_slozky,pole}=[shluciky.euk_norm1{citac_slozky,pole} nanmean(euk(ind))/nanmean(euk)];
                shluciky.density_norm1{citac_slozky,pole}=[shluciky.density_norm1{citac_slozky,pole} nanmean(density(ind))/nanmean(density)];
 
                
                shluciky.euk_norm2{citac_slozky,pole}=[shluciky.euk_norm2{citac_slozky,pole} nanmean(euk(ind))/nanmean(euk(ind2))];
                shluciky.density_norm2{citac_slozky,pole}=[shluciky.density_norm2{citac_slozky,pole} nanmean(density(ind))/nanmean(density(ind2))];
                
                
                shluciky.cisla{citac_slozky,pole}=[shluciky.cisla{citac_slozky,pole} cislo];
                shluciky.cer{citac_slozky,pole}=[shluciky.cer{citac_slozky,pole} nanmean(cer(ind))];
                shluciky.zel{citac_slozky,pole}=[shluciky.zel{citac_slozky,pole} nanmean(zel(ind))];
                shluciky.propca{citac_slozky,pole}=[shluciky.propca{citac_slozky,pole} nanmean(propca(:,ind),2)];
                
                shluciky.propca_norm1{citac_slozky,pole}=[shluciky.propca_norm1{citac_slozky,pole} nanmean(propca(:,ind),2)./nanmean(propca(:,:),2)];
                shluciky.propca_norm2{citac_slozky,pole}=[shluciky.propca_norm2{citac_slozky,pole} nanmean(propca(:,ind),2)./nanmean(propca(:,ind2),2)];
                

%                 shluciky.typ_smrti{citac_slozky,pole}=[shluciky.typ_smrti{citac_slozky,pole} jak];
                
                
                ind_j=kdy-99:kdy;
                ind_j(ind_j<=0)=[];
                ind_j(ind_j>length(mass))=[];
                
                shluciky.area_j{citac_slozky,pole}=[shluciky.area_j{citac_slozky,pole} nanmean(area_j(ind))];
                shluciky.density_j{citac_slozky,pole}=[shluciky.density_j{citac_slozky,pole} nanmean(density_j(ind))];
                shluciky.mod_j{citac_slozky,pole}=[shluciky.mod_j{citac_slozky,pole} nanmean(mod(ind))];
                
                
                peak_zel=nanmean(zel(ind2));
                zel_tresh=zel<(peak_zel*0.33);
                zel_tresh(kdy:end)=0;
                nabeh=find(zel_tresh,1,'last');
                if isempty(nabeh)
                    nabeh=1;
                end
                
                shluciky.barva_spozdeni{citac_slozky,pole}=[shluciky.barva_spozdeni{citac_slozky,pole} kdy-nabeh];
                
                
                
%                 figure(1)
%                 zel_norm=mat2gray(zel,[0 10]);
%                 cer_norm=mat2gray(cer,[0 10]);
%                 plot(1:length(zel_norm),zel_norm,'g')
%                 hold on
%                 plot(1:length(cer_norm),cer_norm,'r')
%                 plot(nabeh,zel_norm(nabeh),'b*')
%                 plot(kdy,zel_norm(kdy),'y*')
%                 hold off
%                 drawnow;

                
            end
            
            
        end
        
        
    end
    
end

save('shluciky.mat','shluciky')