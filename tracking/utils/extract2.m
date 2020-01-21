function signaly=extract2(data,maska)

maska=maska>0;

padsize=floor(length(maska)/2);
data=padarray(data,[0,padsize],'replicate','both');

citac=0;
for k=padsize+1:length(data)-padsize
    okno1=data(k-padsize:k);
    okno2=data(k:k+padsize);
    citac=citac+1;
    signaly(citac,:)=[sum(okno1) , sum(okno2) ] ;
    
end