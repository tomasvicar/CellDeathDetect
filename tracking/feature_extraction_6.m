clc;clear all;close all;
addpath('utils')


qpi_filename='example_data/QPI_DU145_st_1.tif';





red_filename=strrep(qpi_filename,'QPI_','RED_');
green_filename=strrep(qpi_filename,'QPI_','GREEN_');
blue_filename=strrep(qpi_filename,'QPI_','BLUE_');
blue01_filename=strrep(qpi_filename,'QPI_','BLUE01_');
bluenorm_filename=strrep(qpi_filename,'QPI_','BLUEnorm_');
greennorm_filename=strrep(qpi_filename,'QPI_','GREENnorm_');
rednorm_filename=strrep(qpi_filename,'QPI_','REDnorm_');
mixqpiblue_filename=strrep(qpi_filename,'QPI_','mixqpiblue_');
qpi01_filename=strrep(qpi_filename,'QPI_','QPI01_');
fgblue_filename=strrep(qpi_filename,'QPI_','fgblue_');
fgqpi_filename=strrep(qpi_filename,'QPI_','fgqpi_');


init_filename=strrep(strrep(qpi_filename,'QPI_','init_'),'.tif','.mat');
tracking_filename=strrep(strrep(qpi_filename,'QPI_','tracking_'),'.tif','.mat');

segmentation_filename=strrep(strrep(qpi_filename,'QPI_','segmentation_'),'.tif','.mat');

segmentationFilt_filename=strrep(strrep(qpi_filename,'QPI_','segmentationFilt_'),'.tif','.mat');


features_filename=strrep(strrep(qpi_filename,'QPI_','features_'),'.tif','.mat');


load(segmentationFilt_filename)
seg_jad=segmentace_jadra_fitl(:,:,end:-1:1);
seg_bun=segmentace_bunky_filt(:,:,end:-1:1);



max_c=max(seg_jad(:));

        cit=0;
        
info=imfinfo(qpi_filename);
        
for k=1:length(info)
    cit=cit+1

    slice_num=k;
    
    qpi=single(imread(qpi_filename,slice_num));
    
    cervena=single(imread(rednorm_filename,slice_num));
    zelena=single(imread(greennorm_filename,slice_num));
    
    dapi=single(imread(blue_filename,slice_num));
    
    smichany=imread(mixqpiblue_filename,k);

    
    qpi_pg=qpi/2.5464;%tohle je špatnì - má se to dìlit - opraveno v dalším skriptu

    


    seg_j=seg_jad(:,:,cit);
    seg_b=seg_bun(:,:,cit);

    if cit==1
        seg_j_old=seg_jad(:,:,cit);
        seg_b_old=seg_bun(:,:,cit);
        qpi_old=qpi;
    else
        seg_j_old=seg_jad(:,:,cit-1);
        seg_b_old=seg_bun(:,:,cit-1);
    end

    for kk=1:max_c
        parametry(kk).area_b(cit)=nan;
        parametry(kk).area_j(cit)=nan;
        parametry(kk).cer_j(cit)=nan;
        parametry(kk).cer_kor_j(cit)=nan;
        parametry(kk).mod_j(cit)=nan;
        parametry(kk).zel_j(cit)=nan;
        parametry(kk).cer_b(cit)=nan;
        parametry(kk).zel_b(cit)=nan;
        parametry(kk).density(cit)=nan;
        parametry(kk).density_j(cit)=nan;
        parametry(kk).mass(cit)=nan;
        parametry(kk).mass_j(cit)=nan;
        parametry(kk).circularity(cit)=nan;
        parametry(kk).pomer_jb(cit)=nan;
        parametry(kk).euk(cit)=nan;
        parametry(kk).bin_zmena(cit)=nan;
        parametry(kk).hist(cit,1:256)=nan;
        parametry(kk).okraj(cit)=nan;
        parametry(kk).obvod(cit)=nan;
        parametry(kk).Centroid(cit,1:2)=nan;
        parametry(kk).WeightedCentroid(cit,1:2)=nan;
        parametry(kk).Weightedrychlost(cit)=nan;
        parametry(kk).rychlost(cit)=nan;
        parametry(kk).Eccentricity(cit)=nan;
    end
    %             
    %             
    pom=regionprops(seg_j,'Area');
    pomm = cat(1, pom.Area);
    pomm(pomm==0)=nan;
    area_j=pomm/2.5464;
    for kk=1:length(pomm)
        parametry(kk).area_j(cit)=pomm(kk);
    end

    pom=regionprops(seg_b,'Area');
    pomm = cat(1, pom.Area);
    pomm(pomm==0)=nan;
    area_b=pomm/2.5464;
    for kk=1:length(pomm)
        parametry(kk).area_b(cit)=pomm(kk);
    end



    pom=regionprops(seg_j,cervena,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).cer_j(cit)=pomm(kk);
    end


%     pom=regionprops(seg_j,cervena_kor,'MeanIntensity');
%     pomm = cat(1, pom.MeanIntensity);
%     for kk=1:length(pomm)
%         parametry(kk).cer_kor_j(cit)=pomm(kk);
%     end

    pom=regionprops(seg_j,dapi,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).mod_j(cit)=pomm(kk);
    end

    pom=regionprops(seg_j,zelena,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).zel_j(cit)=pomm(kk);
    end



    pom=regionprops(seg_b,cervena,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).cer_b(cit)=pomm(kk);
    end


    pom=regionprops(seg_b,zelena,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).zel_b(cit)=pomm(kk);
    end





    %             pomx=regionprops(seg_b,qpi,'MeanIntensity','Area');
    %             sum_um = cat(1, pomx.MeanIntensity).*cat(1, pomx.Area);
    % %             area_px = cat(1, pom.Area);
    % %             area_um=area_px*2.546;
    %             mass_tmp=sum_um/2.564;

    pom=regionprops(seg_b,qpi_pg,'MeanIntensity','Area');
    pomm = cat(1, pom.MeanIntensity);
    area_pom = cat(1, pom.Area);
    for kk=1:length(pomm)
        parametry(kk).mass(cit)=pomm(kk).*area_pom(kk);
    end
    %             mas_tmp2=pomm.*area_pom;


    pom=regionprops(seg_j,qpi_pg,'MeanIntensity','Area');
    pomm = cat(1, pom.MeanIntensity);
    area_pom = cat(1, pom.Area);
    for kk=1:length(pomm)
        parametry(kk).mass_j(cit)=pomm(kk).*area_pom(kk);
    end





    pom=regionprops(seg_b,qpi,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).density(cit)=pomm(kk);
    end

    pom=regionprops(seg_j,qpi,'MeanIntensity');
    pomm = cat(1, pom.MeanIntensity);
    for kk=1:length(pomm)
        parametry(kk).density_j(cit)=pomm(kk);
    end



    pom=regionprops(seg_b,'Perimeter');
    pomm = cat(1, pom.Perimeter);
    for kk=1:length(pomm)
        parametry(kk).circularity(cit)=4*pi*area_b(kk)./(pomm(kk).^2);
    end


    pomm =area_j(1:length(area_b))./area_b;
    for kk=1:length(pomm)
        parametry(kk).pomer_jb(cit)=pomm(kk);
    end


    pomm =euklidik(qpi_old,qpi,seg_b_old,seg_b);
    for kk=1:length(pomm)
        parametry(kk).euk(cit)=pomm(kk);
    end


    qpi_pom=mat2gray(qpi,[-0.1 2]);
    pomm=histiky(qpi_pom,seg_b);
    for kk=1:size(pomm,2)
        parametry(kk).hist(cit,:)=pomm(:,kk);
    end


    pomm=zmenicky(seg_b_old,seg_b);
    for kk=1:length(pomm)
        parametry(kk).bin_zmena(cit)=pomm(kk);
    end

    pomm=okrajek(seg_b);
    for kk=1:length(pomm)
        parametry(kk).okraj(cit)=pomm(kk);
    end

    pomm=regionprops(seg_b,'Perimeter');
    pomm = cat(1, pomm.Perimeter);
    for kk=1:length(pomm)
        parametry(kk).obvod(cit)=pomm(kk);
    end

    pomm=regionprops(seg_b,'Eccentricity');
    pomm = cat(1, pomm.Eccentricity);
    for kk=1:length(pomm)
        parametry(kk).Eccentricity(cit)=pomm(kk);
    end


    %             pomm=four_desk(seg_b);
    %             for kk=1:size(pomm,2)
    %                 parametry(kk).four_d(cit,:)=pomm(:,kk);
    %             end

    pomm=regionprops(seg_b,'Centroid');
    pomm = cat(1, pomm.Centroid);
    pomm2=regionprops(seg_b_old,'Centroid');
    pomm2 = cat(1, pomm2.Centroid);
    pomm=sqrt((pomm(:,1)-pomm2(:,1)).^2+(pomm(:,2)-pomm2(:,2)).^2);
    for kk=1:length(pomm)
        parametry(kk).rychlost(cit)=pomm(kk);
    end


    pomm=regionprops(seg_b,'Centroid');
    pomm = cat(1, pomm.Centroid)';
    for kk=1:size(pomm,2)
        parametry(kk).Centroid(cit,:)=pomm(:,kk);
    end

    pomm=regionprops(seg_b,qpi,'WeightedCentroid');
    pomm = cat(1, pomm.WeightedCentroid)';
    for kk=1:size(pomm,2)
        parametry(kk).WeightedCentroid(cit,:)=pomm(:,kk);
    end



    pomm=regionprops(seg_b,qpi,'WeightedCentroid');
    pomm = cat(1, pomm.WeightedCentroid);
    pomm2=regionprops(seg_b_old,qpi_old,'WeightedCentroid');
    pomm2 = cat(1, pomm2.WeightedCentroid);
    pomm=sqrt((pomm(:,1)-pomm2(:,1)).^2+(pomm(:,2)-pomm2(:,2)).^2);
    for kk=1:size(pomm,1)
        parametry(kk).Weightedrychlost(cit)=pomm(kk);
    end


    qpi_old=qpi;

    
end


save(features_filename,'parametry')


