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


load(segmentation_filename)



segmentace_jadra=segmentace_jadra(:,:,1:size(segmentace_bunky,3));
               
        
track=segmentace_bunky;
vymazat=zeros(1,max(track(:)));
poprve=1;
for snimky=1:size(segmentace_bunky,3)
%             a=aa(:,:,snimky);
    ll=track(:,:,snimky);

    if poprve
        poprve=0;
        pritomnost_old=unique(ll(ll>0));
        ll_old=ll;
    else
        pritomnost=unique(ll(ll>0));
        navic=pritomnost(~ismember(pritomnost,pritomnost_old));
        zmizel=pritomnost_old(~ismember(pritomnost_old,pritomnost));
        vymazat(navic)=1;
        vymazat(zmizel)=1;

        if ~isempty(navic)
            for k=navic'
                puvodni=ll==k;
                nejvic=ll_old(puvodni);
                nejvic(nejvic==0)=[];
                kterej=mode(nejvic);
                kolik=sum(nejvic==kterej);
                if kolik>(0.2*sum(sum(puvodni)))
                    vymazat(kterej)=1;
                end
            end
        end

        if ~isempty(zmizel)
            for k=zmizel'
                puvodni=ll_old==k;
                nejvic=ll(puvodni);
                nejvic(nejvic==0)=[];
                kterej=mode(nejvic);
                kolik=sum(nejvic==kterej);
                if kolik>(0.2*sum(sum(puvodni)))
                    vymazat(kterej)=1;
                end
            end
        end

        ll_old=ll;
        pritomnost_old=unique(ll(ll>0));
    end

end



segmentace_jadra_fitl=segmentace_jadra;
segmentace_bunky_filt=segmentace_bunky;
for k=find(vymazat)
    segmentace_jadra_fitl(segmentace_jadra_fitl==k)=0;
    segmentace_bunky_filt(segmentace_bunky_filt==k)=0;
end



save(segmentationFilt_filename,'segmentace_jadra_fitl','segmentace_bunky_filt')



