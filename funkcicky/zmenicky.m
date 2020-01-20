function h= zmenicky(seg_b_old,seg_b)

%             

l=seg_b;

ml=max(l(:));
for k=1:ml
    pom=sum(sum((seg_b_old==k)~=(seg_b==k)));
    
    
    
    if sum(sum(k==l))==0
        pom=nan;
    end
    
    
    h(k)=pom;
    
    
    
end