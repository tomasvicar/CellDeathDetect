function h=four_desk(seg_b)

%             

l=seg_b;

ml=max(l(:));
for k=1:ml
    pom=l==k;
    if sum(pom(:))>0
        FD = gfd(pom,3,12);
    else
        FD=nan(52,1);
    end
    
    
    h(:,k)=FD;
    
    
    
end