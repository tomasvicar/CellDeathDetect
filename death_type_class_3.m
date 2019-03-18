%Composed by Tomas Vicar 15/03/2019, 
% Department of Biomedical Engineering, Brno University of Technology  
% vicar@feec.vutbr.cz

clc;clear all;close all;
addpath('utils')
mkdir('tmp')

data_folder='..\preulozene_na_poslani\';%set the data folder


listing=subdir([data_folder '*.xlsx']);
listing={listing(:).name};

experiment_names={};
CDS_all=[];
Density_all=[];
death_types=[];

for name=listing
    name{1}
    name_table=name{1};
    name_tmp=name{1}(1:end-5);
    name_mask=[strrep(name_tmp,'labels_','mask_') '.tif'];
    name_qpi=[strrep(name_tmp,'labels_','QPI_') '.tif'];
    name_features=[strrep(strrep(name_tmp,'labels_','features_'),data_folder,'tmp\') '.mat'];
    name_tmp2=split(name_tmp,'\');
    name_tmp2=name_tmp2{end};
    experiment_name=name_tmp2(8:end-2);
    
    
    T=readtable(name_table);
    
    
    load(name_features)
    
    for k=1:size(T,1)
        
        death_pos=T.death_frame(k);
        death_type=T.death_type(k);
        
        Density=features(k).Density;
        CDS=features(k).CDS;
        
        if ~isnan(death_pos)&&death_type<3
        
            window=200;
            ind=death_pos-(window-1):death_pos;
            ind(ind<=0)=[];
            ind(ind>length(Density))=[];

            Density_mean=nanmean(Density(ind));
            CDS_mean=nanmean(CDS(ind));

            experiment_names=[experiment_names experiment_name];
            CDS_all=[ CDS_all CDS_mean];
            Density_all=[Density_all Density_mean];
            death_types=[death_types,death_type];
            
        end
        
    end
end




for cell_line={'DU145','LNCaP','PNT1A'}
    
    line_ind=cellfun(@(x) contains(x,cell_line{1}),experiment_names);
    
    
    X=[CDS_all(line_ind);Density_all(line_ind)]';
    Y=[death_types(line_ind)]';
    
    Mdl = fitcsvm(X,Y,'Standardize',1);
    
    
    for experiment={'bp','st','do'}
    
        line_experiment_ind=cellfun(@(x) contains(x,cell_line{1})&&contains(x,experiment{1}),experiment_names);
        
        
        X=[CDS_all(line_experiment_ind);Density_all(line_experiment_ind)]';
        Y=[death_types(line_experiment_ind)]';

        
        Y_pred=predict(Mdl,X);
        acc=sum(Y_pred==Y)/numel(Y);
        
        
        m=Mdl;
        c=m.Bias;
        a=m.Beta(1);
        b=m.Beta(2);
        mx=m.Mu(1);
        my=m.Mu(2);
        sx=m.Sigma(1);
        sy=m.Sigma(2);
        x0=((-c+b*my/sy)/a)*sx+mx;
        y0=((-c+a*mx/sx)/b)*sy+my;
        
        
        cds_lim=[0 0.01];
        density_lim=[0 1];
        CDS=CDS_all(line_experiment_ind);
        Density=Density_all(line_experiment_ind);
        CDS(CDS>cds_lim(2))=cds_lim(2);
        Density(Density>density_lim(2))=density_lim(2);
        
        figure()
        hold on
        plot([x0 0],[0 y0],'k');
        plot(CDS(Y==1),Density(Y==1),'r*');
        plot(CDS(Y==2),Density(Y==2),'b*');
        title([cell_line{1} ' ' experiment{1} ' ' 'acc-' num2str(acc)])
        xlabel('CDS')
        ylabel('Density')
        xlim(cds_lim);
        ylim(density_lim);
        
    end
end








