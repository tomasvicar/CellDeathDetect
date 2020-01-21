function pomm=okrajek(seg_b)


okraj=false(size(seg_b));
okraj(:,[1 end])=true;
okraj([1 end],:)=true;


l=seg_b;

ml=max(l(:));
for k=1:ml
    pom=sum(sum((l==k).*okraj));
    
    pomm(k)=pom;
end