function vys=conv1_rep(sig,maska)
padsize=round(length(maska)/2+1);
sigg=padarray(sig,[0,padsize],'replicate','both');
vys=conv(sigg, maska, 'same') ;
vys=vys(padsize+1:end-padsize);