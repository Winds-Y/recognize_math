close all;clear;

I=imread('rgb_plant.jpg');%读取图像
figure(1); 
subplot(2,2,1);%将图一分为四块，图一的第一幅图F:\workspace\MathModel\recognize
 
imshow(I), title('提取车牌后图像'); 
%%%%%%%%%%二值化图像
%%%%%%%% 
I1 = rgb2gray(I);%彩色图像转化为灰度图像
 
h=graythresh(I1);  
%I1=im2bw(I1,h);%将灰度图像二值化
I1=imbinarize(I1,h);
figure(1);  
subplot(2,2,2);%图一的第二幅图

% I1=imread('binary_plant.jpg');
imshow(I1),title('车牌二值化后图像'); 
 
%%%%%%%%%%%%去除杂质
%%%%%%%%%%%% 
[y,~,~]=size(I1);%计算I1的大小
  
%%%%%%%%%对图像进行开闭运算
%%%%%%%% 
SE=strel('disk',fix(y/45));%创建一个平坦的圆盘形结构元素
 I2=imopen(I1,SE);%取圆盘形的开运算 subplot(2,2,3);%图一的第三幅图
 
imshow(I2),title('I2开运算后图像');
SE=strel('diamond',fix(y/140));%创建一个平坦的菱形结构元素
I3=imclose(I2,SE);%取菱形结构的闭运算 subplot(2,2,4);%图一的第四幅图
 
imshow(I3),title('I3闭运算后图像'); I4=double(I3);%变为双精度
  
%%%%%%%%%%%%%%%计算像素
%%%%%%%%%%%%%%% 
%%%%%%%计算行像素
%%%%%%%% 
Y1=sum(I1,2);
% figure(2);  
% plot(Y1,0:y-1),title('行方向像素点灰度值累计和'),xlabel('累计像素量'),ylabel('行值'); 
%%%%%去除行方向边框
%%%%%%%%%% 
Py0=0;
Py1=y;
[row,col]=size(I4);
for i=1:row
    if Y1(i)/col >0.3 && Y1(i)/col<0.6
        break;
    else 
        Py0=i;
    end
end
for i=row:-1:1
    if Y1(i)/col>0.3 && Y1(i)/col<0.6
        break;
    else 
        Py1=i;
    end
end

Z1=I1(Py0:Py1,:,:);%将二值图像上下边框去除
 
figure(3);  
imshow(Z1),title('将二值图像上下边框去除后图像');%将二值图像上下边框去除后图像显示来
  
[y,x,z]=size(Z1);%计算此时图像的大小

%%%%%%%%%%%%计算列像素
%%%%%%%%%% 
X1=sum(Z1,1);


figure(4);  
plot(0:x-1,X1),title('列方向像素点灰度值累计和'),xlabel('列值'),ylabel('累计像素量'); 
%%%%%%%%去除垂直边框
%%%%%%%%% 
[row,col]=size(Z1);
x0=1;
x1=col;
while x0<=col && (X1(x0)==0 || X1(x0)==row)
    x0=x0+1;
end
while x1>=1 &&(X1(x1)==0 || X1(x1)==row)
    x1=x1-1;
end
Z2=Z1(:,x0:x1,:);%将二值图像左右边框去除
figure(5);
imshow(Z2),title('将二值图像垂直边框去除后图像');%将二值图像垂直边框去除后图像显示出来
[~,col]=size(Z2);
Z3=sum(Z2,1);
len=length(Z3(Z3==0));
mark=1:len;
cnt=1;
for i=1:col
    if Z3(i)==0
        mark(cnt)=i;
        cnt=cnt+1;
    end
end
i=1;
mark_sub=[];
cnt=1;
while i<=len
    j=i+1;
    while j<=len
        if mark(j)-mark(j-1)==1
            j=j+1;
        else
            break;
        end
    end
    mark_sub(cnt,1)=mark(i);
    mark_sub(cnt,2)=mark(j-1);
    cnt=cnt+1;
    i=j;
end
len=length(Z3);
char=reshape(mark_sub',1,[]);
char=[2 char len+1];
char_sub=[];
cnt=1;
for i=1:2:length(char)-1
    char_sub(cnt,1)=char(i)-1;
    char_sub(cnt,2)=char(i+1)-1;
    cnt=cnt+1;
end
[row,col]=size(char_sub);
for i=1:row
    left=char_sub(i,1);
    right=char_sub(i,2);
    Z4=Z2(:,left:right,:);
    subplot(1,row,i);
    imshow(Z4);
end
%{  
Px0=1; 
Px1=1;  
%%%%%%%%%再次计算列方向像素
%%%%%%%%% 
[y,x,z]=size(Z2);%计算此时图像的大小
X1=zeros(1,x); 
for j=1:x 
    for i=1:y  
        if(Z2(i,j,1)==1) 
            X1(1,j)= X1(1,j)+1;%计算I3第j列有几个一
        end 
    end 
end  
%%%%%%%去除圆点
%%%%%% 
[y,x,z]=size(Z2); 
Z2=double(Z2); 
x1=fix(x*110/409); 
x2=fix(x*128/409); 
for i=1:y 
    for j=x1:x2 
        Z2(i,j)=0; 
    end 
end 
figure(6);  
imshow(Z2),title('去除圆点后图像');  
%%%%%%%%%%%%%对图像分割
%%%%%%%%%%%%%% 
y=fix(x*90/409);  
%%%%%%%用投影法分割
%%%%%% 
for i=1:7  
    while ((X1(1,Px0)<10)&&(Px0<x))  
        Px0=Px0+1;%找到待分割字符左边的位置
    end 
    Px1=Px0; 
    a=1;  
    while (((X1(1,Px1)>=10)&&(Px1<x))||((Px1<x)&&((a/y)<=0.5))) 
        Px1=Px1+1;%找到待分割字符右边的位置
        a=Px1-Px0; 
    end  
    Z3=Z2(:,Px0:Px1,:);%二值化图像分割后
    figure(7); 
    subplot(1,7,i);   
    imshow(Z3);%将二值化图像分割后显示出来
    %%变换为标准子图
 
    Z4=imresize(Z3,[88 40]);%将分割后的二值图变换为标准子图
    figure(8); 
    subplot(1,7,i);  
    imshow(Z4),title('标准子图');%将标准子图显示出来
    Px0=Px1; 
end  
%}
