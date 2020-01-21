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

info=imfinfo(qpi_filename);

for slice_num=1:length(info)
    
    qpi=single(imread(qpi_filename,slice_num));
    red=single(imread(red_filename,slice_num));
    green=single(imread(green_filename,slice_num));
    blue=single(imread(blue_filename,slice_num));
    
    
    
    qpi01=qpi;
    qpi01=medfilt2(qpi01,[3 3]);
    qpi01=imgaussfilt(qpi01,0.5);
    qpi01=mat2gray(qpi01,[-0.1 2]);


    bluenorm=(blue-mean(blue(:)))/std(blue(:));

    
    blue01=blue;
    blue01=medfilt2(blue01,[3 3]);
    blue01=imgaussfilt(blue01,0.5);
    blue01=mat2gray(blue01,[0 1000]);
    
    
    
    
    mixqpiblue=cat(3,qpi01,qpi01,qpi01); %just for visualization
    mixqpiblue(:,:,3)=mixqpiblue(:,:,3)+mat2gray(blue01,[0.1 0.45]);
    mixqpiblue=uint8(mixqpiblue*255);
    
    
    
    greennorm=(green-mean(green(:)))/std(green(:));

    rednorm=(red-mean(red(:)))/std(red(:));

    fgqpi=segmentace_popredi(qpi01);
    fgblue=segmentace_popredi_dapi(blue01);

    
    
    
    tiff_stack(blue01_filename,blue01,slice_num)
    tiff_stack(bluenorm_filename,bluenorm,slice_num)
    tiff_stack(greennorm_filename,greennorm,slice_num)
    tiff_stack(rednorm_filename,rednorm,slice_num)
    tiff_stack_uint8_color(mixqpiblue_filename,mixqpiblue,slice_num)
    tiff_stack(qpi01_filename,qpi01,slice_num)
    tiff_stack(fgblue_filename,fgblue,slice_num)
    tiff_stack(fgqpi_filename,fgqpi,slice_num)
   
    
    
end
    
    
    
