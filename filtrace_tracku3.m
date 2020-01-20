clc;clear all;close all;
addpath('funkcicky')

% co={'../skluzavky_dataset_pouzita_data/LNCaP_st','../skluzavky_dataset_pouzita_data/LNCaP_do','../skluzavky_dataset_pouzita_data/PNT1A_st','../skluzavky_dataset_pouzita_data/PNT1A_do','../skluzavky_dataset_pouzita_data/PNT1A_Fluo'};

% co={'../skluzavky_dataset_pouzita_data/LNCaP_Fluo'};

co={'../2019-11-15_12-48-14_experiment_cast'};



citac=0;
for c=co
    cc=c{1};
    cc=cc(4:end);
    
    for pole=1:7
        citac=citac+1;
                
        
        [pole]
        cc
        
        load([c{1} '/' num2str(pole) 'masky_segmentace.mat'])
        
        segmentace_jadra=segmentace_jadra(:,:,1:size(segmentace_bunky,3));
               
        
        track=segmentace_bunky;
        vymazat=zeros(1,max(track(:)));
        poprve=1;
        for snimky=1:size(segmentace_bunky,3)
            snimky
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
        
        

        
  
        save([c{1} '/' num2str(pole) 'masky_segmentace_filt.mat'],'segmentace_jadra_fitl','segmentace_bunky_filt','-v7.3')
        
        drawnow;
        pause(10)
    end
end







