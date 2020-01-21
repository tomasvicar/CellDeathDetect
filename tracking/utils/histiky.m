function h= histiky(qpi_pom,seg_b)

%             

l=seg_b;

ml=max(l(:));
for k=1:ml
    pom=imhist(qpi_pom(l==k));
    
    if sum(pom)==0
        pom(pom==0)=nan;
    end
    
    
    h(:,k)=pom;
    
    
    
end