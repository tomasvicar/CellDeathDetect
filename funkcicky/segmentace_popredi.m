function maska=segmentace_popredi(qpi)

maska=qpi>mat2gray(0.048,[-0.1,2] );
maska=imclose(maska,strel('disk',3));
maska = fill_holes(maska, 150);
maska=bwareafilt(maska,[300 9999999]);