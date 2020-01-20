function mask=centroid2mask(cent,velikost)

mask=false(velikost);

mask(sub2ind(velikost, cent(:,2), cent(:,1)))=true;

