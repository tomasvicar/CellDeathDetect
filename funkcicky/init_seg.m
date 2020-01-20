function vysledek=init_seg(qpi,dapi,init_maska,init_body)


a=dapi;

puntiky=centroid2mask(init_body, size(a) );


aw=mat2gray(-a);

ai = imimposemin(aw, puntiky>0);

vysledek=(watershed(ai)>0)&init_maska;




