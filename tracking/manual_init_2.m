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


info=imfinfo(qpi_filename);


for slice_num=1:length(info)
    
    qpi01(:,:,slice_num)=imread(qpi01_filename,slice_num);
    blue01(:,:,slice_num)=imread(blue01_filename,slice_num);
    
    mixqpiblue(:,:,slice_num,:)=imread(mixqpiblue_filename,slice_num);
    
end
    
    
mixqpiblue=mixqpiblue(:,:,end:-1:1,:);
blue01=blue01(:,:,end:-1:1);
qpi01=qpi01(:,:,end:-1:1);

[teckyy,masky_jadraa]=detekce(qpi01(:,:,1),blue01(:,:,1));
pom=regionprops(teckyy>0,'centroid');
init_points=cat(1,pom.Centroid);
init_points=inicializace_a_deleni(mixqpiblue,init_points);

save(init_filename,'init_points')

