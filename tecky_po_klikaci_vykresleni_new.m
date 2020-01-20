clc;clear all;close all force;
addpath('funkcicky')



load('shluciky.mat')


co={'../2019-11-15_12-48-14_experiment_cast'};




xli=[0 0.01];
yli=[0 1];




euk=[shluciky.euk{:,:}];
density=[shluciky.density{:,:}];
cisla=[shluciky.cisla{:,:}];
cer=[shluciky.cer{:,:}];
zel=[shluciky.zel{:,:}];
propca=[shluciky.propca{:,:}];
typ_smrti=[shluciky.typ_smrti{:,:}];
spozdeni=[shluciky.barva_spozdeni{:,:}];
area_j=[shluciky.area_j{:,:}];
density_j=[shluciky.density_j{:,:}];
mod=[shluciky.mod_j{:,:}];


euk(euk>xli(2))=xli(2);
density(density>yli(2))=yli(2);
figure()
hold on
plot(euk,density,'k*');



xlim(xli)
                ylim(yli)
xlabel('euk')
ylabel('dens')
title(['euk-dens' ' - ' num2str(spravne_celkem/pocet_celkem)])
