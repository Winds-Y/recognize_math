A=imread('after_car.jpg');    
I = rgb2gray(A);  
subplot(2,2,1);   
imshow(I);    
title('ԭͼ');   
hx=[-1 -2 -1;0 0 0 ;1 2 1];%����sobel��ֱ�ݶ�ģ��  
%hx=[-1 -1 -1;0 0 0;1 1 1];
hy=hx';                    %����sobelˮƽ�ݶ�ģ��  
gradx=filter2(hx,I,'same');  
subplot(2,2,2);  
imshow(gradx,[]);  
title('ͼ���sobel��ֱ�ݶ�');  
   
grady=filter2(hy,I,'same');  
grady=abs(grady); %����ͼ���sobelˮƽ�ݶ�  
subplot(2,2,3);  
imshow(grady,[]);  
title('ͼ���sobelˮƽ�ݶ�');  
    
grad=gradx+grady;  %�õ�ͼ���sobel�ݶ�  
subplot(2,2,4);  
imshow(grad,[]);  
title('ͼ���sobel�ݶ�');  

