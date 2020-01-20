function eu= euklidik(data1,data2,maska1,maska2)


l_old=maska1;

l=maska2;

ml=max(l(:));
for k=1:ml
    pom=sqrt(sum((data1(l==k)-data2(l==k)).^2));
    
    pom(pom==0)=nan;
    
    eu(k)=pom;
end