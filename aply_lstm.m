clc;clear all;close all force;



ukladacka_vys=[];





load('pom_data_new.mat')
load('stdd_prumm_pole1.mat')


for pole=1:7
    
    ukladacka_pole=[];
    
    
    qq=cellfun(@(x) x==pole,pole_c);

    testik=qq;
    

for k=1:size(data,2)
    pom=data{k};
    for kk=1:size(pom,1)
        pom(kk,:)=((pom(kk,:)-prumm(kk))/stdd(kk));
    end
    data{k}=pom;
end


XTest=data(testik);


load('model1.mat')

vys=predict(net,XTest);


for k=1:size(vys)
    o_sig=vys{k};
    
    close all
    plot(o_sig)
    
    cislicko=0.1;
    [kolik_o,kde_o]=max(o_sig);
%     kde_o(kde_o<100)=100;
    
    kde_o(kolik_o<cislicko)=-500;

    ukladacka_vys=[ukladacka_vys kde_o];
    ukladacka_pole=[ukladacka_pole kde_o];
    
end

save(['ukladacka_pole' num2str(pole) '.mat'],'ukladacka_pole')
end



graf_o=zeros(1,length(vys{k}));
for k=1:length(ukladacka_vys)
    
    kde_o=ukladacka_vys(k);




    pom=ones(size(graf_o));
    if kde_o>0
        pom(kde_o:end)=0;
    end
    graf_o=graf_o+pom;

end



tmp=graf_o/max(graf_o);
it50auto=find(tmp<0.5,1,'first');


figure()
hold on

plot((1:length(graf_o))/20,graf_o/max(graf_o(:)))







