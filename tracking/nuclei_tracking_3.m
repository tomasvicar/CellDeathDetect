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


info=imfinfo(qpi_filename);


for slice_num=1:length(info)
    
    qpi01(:,:,slice_num)=imread(qpi01_filename,slice_num);
    blue01(:,:,slice_num)=imread(blue01_filename,slice_num);
    
    mixqpiblue(:,:,slice_num,:)=imread(mixqpiblue_filename,slice_num);
    
end

    
mixqpiblue=mixqpiblue(:,:,end:-1:1,:);
blue01=blue01(:,:,end:-1:1);
qpi01=qpi01(:,:,end:-1:1);

load(init_filename)
        
        


mu=init_points;
sigma=repmat(3*eye(2),[1 1 size(init_points,1)]);
p=ones(1,size(init_points,1));
zabit=zeros(1,size(init_points,1));
pouzite=ones(1,size(init_points,1));
nenalezen=ones(1,size(init_points,1));

tracking_results=[];
puntiky_old=init_points;


for k=1:size(blue01,3)
    k

    [mu_new,sigma_new,p_new,zabit_new,nenalezen_new,maska_jadra,pouzite_new]=segmentace2(qpi01(:,:,k),blue01(:,:,k),mu,sigma,p,zabit,nenalezen,pouzite);


    puntiky_old=mu;
    puntiky_new=mu_new;

    
   imshow(squeeze(mixqpiblue(:,:,k,:)),[]);
   hold on 
   plot(puntiky_old(find(pouzite),1),puntiky_old(find(pouzite),2),'b*')
   plot(puntiky_new(find(pouzite),1),puntiky_new(find(pouzite),2),'r*')
   title(num2str(k))
   hold off
   drawnow;

   
   
    mu=mu_new;
    sigma=sigma_new;
    p=p_new;
    zabit=zabit_new;
    nenalezen=nenalezen_new;
    pouzite=pouzite_new;

    tracking_results(k).mu=mu;
    tracking_results(k).sigma=sigma;
    tracking_results(k).p=p;
    tracking_results(k).zabit=zabit;
    tracking_results(k).nenalezen=nenalezen;
    tracking_results(k).pouzite=pouzite;
    tracking_results(k).maska_jadra=maska_jadra>0;

end
save(tracking_filename,'tracking_results','-v7.3')
drawnow;

