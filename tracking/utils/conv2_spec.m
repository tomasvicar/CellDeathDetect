function y=conv2_spec(x,h)

%periodická
y=real(ifft2(fft2(x,size(x,1),size(x,2)).*fft2(h,size(x,1),size(x,2))));

y=circshift(y,floor(-1*[size(h)]/2));


% aperiodická

% y=real(ifft2(fft2(x,size(x,1)+size(h,1)-1,size(x,2)+size(h,2)-1).*fft2(h,size(x,1)+size(h,1)-1,size(x,2)+size(h,2)-1)));
% 
% y=y((size(h,1)-1)/2:size(y,1)-(size(h,1)-1)/2-1,(size(h,2)-1)/2:size(y,2)-(size(h,2)-1)/2-1);
% 


end