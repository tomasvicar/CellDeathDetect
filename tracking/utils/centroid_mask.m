function mpp=centroid_mask(m)

            mp=regionprops(m>0,'Centroid');
            mp = cat(1, mp.Centroid);
            mpp=zeros(size(m));
            for kkk=1:length(mp)
                mpp(round(mp(kkk,2)),round(mp(kkk,1)))=1;
            end
            