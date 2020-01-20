function maska=segmentace_popredi_dapi(dapi)

area_change=0.85;
delta=5;
min_area=80;
% max_area=1

ab=dapi;

I=uint8(255*mat2gray(imgaussfilt(ab,1)));



[r,~]=vl_mser(I,'MinDiversity',0.4,...
    'MaxVariation',area_change,...
    'Delta',delta,...
    'MinArea', min_area/ numel(I),...
    'MaxArea',1);

M1 = zeros(size(I)) ;
for x=1:length(r)
    s = vl_erfill(I,r(x)) ;
    M1(s) = M1(s) + 1;
end




suma=M1;

maska=suma>0;
