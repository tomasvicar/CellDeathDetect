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


info=imfinfo(qpi_filename);


for slice_num=1:length(info)
    
    qpi01(:,:,slice_num)=imread(qpi01_filename,slice_num);
    blue01(:,:,slice_num)=imread(blue01_filename,slice_num);
    
    mixqpiblue(:,:,slice_num,:)=imread(mixqpiblue_filename,slice_num);
    
end


    
mixqpiblue=mixqpiblue(:,:,end:-1:1,:);
blue01=blue01(:,:,end:-1:1);
qpi01=qpi01(:,:,end:-1:1);




load(tracking_filename)

vys_old=tracking_results;


pom=[];
for k=1:length(tracking_results)
    pom(1:length(tracking_results(k).pouzite),k)=tracking_results(k).pouzite;
end
pom=sum(pom,2)>10;

for k=1:length(tracking_results)
    pom2=tracking_results(k).pouzite;
    pom2=pom2.*pom(1:length(pom2))';
    tracking_results(k).pouzite=pom2;
end



segmentace_jadra=zeros([600 600 length(10:length(info)-5)]);
segmentace_bunky=zeros([600 600 length(10:length(info)-5)]);


maska_old=segmentace_popredi(qpi01(:,:,1));



for k=1:size(qpi01,3)
    k
    [jadra,bunky]=segm_podle_gmm(qpi01(:,:,k),blue01(:,:,k),tracking_results(k),maska_old);
    maska_old=bunky>0;
    segmentace_jadra(:,:,k)=jadra;
    segmentace_bunky(:,:,k)=bunky;


   imshow(squeeze(mixqpiblue(:,:,k,:)),[]);
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



end

save(segmentation_filename,'segmentace_jadra','segmentace_bunky','-v7.3')



