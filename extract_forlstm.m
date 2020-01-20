clc;clear all;close all force;
addpath('funkcicky')


%%%%%%area dìl 2.5464^2
slozkaa='../';
co={'2019-11-15_12-48-14_experiment_cast'};


data={};
labely={};
slozka={};
pole_c={};
bunka_c={};
casy_smrti={};
labely01={};


citac=0;
citac_slozky=0;
for c=co
    
    c{1}=[slozkaa c{1}];
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
            
        
            
            euk=euk0;
            cer=cer_j0;
            zel= zel_j0 ;
            mass= mass0 ;
            area= area0 ;
            density= density0 ;
            Eccentricity= Eccentricity0 ;
            Weightedrychlost= Weightedrychlost0 ;
            rychlost= rychlost0 ;
            circularity= circularity0 ;
            bin_zmena= bin_zmena0 ;
            area_j=area_j0;
            density_j=density_j0;
            mod=mod_j0;
            
            
            histik=parametry(cislo).hist;
            histik=conv2(histik,[1 1 1 1 1], 'valid');
            
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
            
            

  
            signaly=[mass;area;euk;density;Weightedrychlost;rychlost;Eccentricity;circularity;maxhist;maxhist_p;entropycka];

            data=[data,signaly];
           
            
            slozka=[slozka,cc];
            pole_c=[pole_c,pole];
            bunka_c=[bunka_c,cislo];
            
            
            
            
            
            
            
        end
        
        
    end
    
end
save('pom_data_new.mat','data','slozka','pole_c','bunka_c');