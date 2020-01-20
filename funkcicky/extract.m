function signaly=extract(data,maska)

maska=maska>0;

padsize=floor(length(maska)/2);
data=padarray(data,[0,padsize],'replicate','both');

citac=0;
for k=padsize+1:length(data)-padsize
    okno=data(k-padsize:k+padsize);
%     okno2=data(k:);
    citac=citac+1;
    signaly(citac,:)=okno(maska) ;
    
end