function mask=centroid2mask_l(cent,velikost)

mask=zeros(velikost);

mask(sub2ind(velikost, cent(:,2), cent(:,1)))=1:size(cent,1);

