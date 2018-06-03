img=imread('plant.jpg');
gray=rgb2gray(img);
[counts,x]=imhist(gray);
[m,n]=size(gray);
level=ostu(counts,m*n)
output=gray;
output(output<level)=0;
output(output>=level)=255;
imshow(output);