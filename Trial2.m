I=imread('car.bmp');
G=rgb2gray(I);
% I=rgb2gray(I);
% gray transform

J=imadjust(G,[0.1 0.9],[0 1],1);

% Edge detection
% Sobel
BW1=edge(G,'sobel');
sobelBW1=im2uint8(BW1)+J;
figure;
%imshow(BW1);
subplot(1,2,1);
imshow(J);
title('original image');
subplot(1,2,2);
imshow(sobelBW1);
title('Sobel augmented image');
% Roberts
BW2=edge(G,'roberts');
robertBW2=im2uint8(BW2)+J;
figure;
%imshow(BW2);
subplot(1,2,1);
imshow(J);
title('original image');
subplot(1,2,2);
imshow(robertBW2);
title('robert augmented image');
% prewitt
BW3=edge(G,'prewitt');
prewittBW3=im2uint8(BW3)+J;
figure;
%imshow(BW3);
subplot(1,2,1);
imshow(J);
title('original image');
subplot(1,2,2);
imshow(prewittBW3);
title('Prewitt augmented image');
% log
BW4=edge(G,'log');
logBW4=im2uint8(BW4)+J;
figure;
%imshow(BW4);
subplot(1,2,1);
imshow(J);
title('original image');
subplot(1,2,2);
imshow(logBW4);
title('Laplacian augmented image');
% canny
BW5=edge(G,'canny');
cannyBW5=im2uint8(BW5)+J;
figure;
%imshow(BW5);
subplot(1,2,1);
imshow(J);
title('original image');
subplot(1,2,2);
imshow(cannyBW5);
title('Canny augmented image');
% gaussian & canny
% h=fspecial('gaussian',5); 
% fI=imfilter(I,h,'replicate');
% BW6=edge(fI,'canny');
% figure;
% imshow(BW6);

figure;
subplot(2,3,1), imshow(BW1); 
title('sobel edge detect'); 
subplot(2,3,2), imshow(BW2); 
title('roberts edge detect'); 
subplot(2,3,3), imshow(BW3); 
title('prewitt edge detect'); 
subplot(2,3,4), imshow(BW4); 
title('log edge detect'); 
subplot(2,3,5), imshow(BW5); 
title('canny edge detect'); 
% subplot(2,3,6), imshow(BW6); 
% title('gasussian&canny edge detect');

figure;
subplot(2,3,1), imshow(sobelBW1); 
title('sobel edge detect'); 
subplot(2,3,2), imshow(robertBW2); 
title('roberts edge detect'); 
subplot(2,3,3), imshow(prewittBW3); 
title('prewitt edge detect'); 
subplot(2,3,4), imshow(logBW4); 
title('laplacian edge detect'); 
subplot(2,3,5), imshow(cannyBW5); 
title('canny edge detect');