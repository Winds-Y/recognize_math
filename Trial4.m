 %Step2 ͼ��Ԥ����   ��ԭʼ�ڰ�ͼ����п������õ�ͼ�񱳾�  
%I1Ϊ�Ҷ�ͼ
I=imread('example15.bmp');
I1=rgb2gray(I);
[m,n]=size(I1);                              %����ͼ��ߴ����
GreyHist=zeros(1,255);                       %Ԥ������ŻҶȳ��ָ��ʵ�����
for k=0:255
    GreyHist(k+1)=length(find(I1==k))/(m*n);  %����ÿ���Ҷȳ��ֵĸ��ʣ��������GreyHist����Ӧλ��
end
figure(3),
subplot(2,2,2);
bar(0:255,GreyHist,'g')                      %����ֱ��ͼ   
title('����ǰ�Ҷ�ֱ��ͼ')
xlabel('�Ҷ�ֵ')
ylabel('���ָ���')
subplot(2,2,1),imshow(I1),title('����ǰ�ڰ�ͼ��');
%�Ҷ�����
%{
I1=double(I1);
ma=double(max(max(I1)));
mi=double(min(min(I1)));
I1=(255/(ma-mi))*I1-(255*mi)/(ma-mi);
I1=uint8(I1);
%}
%figure(4),
subplot(2,2,3);
title('�Ҷ������ڰ�ͼ��');
for k=0:255
    GreyHist(k+1)=length(find(I1==k))/(m*n);                 
end
subplot(2,2,4);
bar(0:255,GreyHist,'b')                                      
title('�����ĻҶ�ֱ��ͼ')
xlabel('�Ҷ�ֵ')
ylabel('���ָ���')

%ͻ��Ŀ�����
SE=strel('disk',16);%�뾶Ϊr=16��Բ��ģ��

ST1=imerode(I1,SE);
I2=imdilate(ST1,SE);

%I2=imopen(I1,SE);%������  ��ģ��SE�ԻҶ�ͼI1���и�ʴ���ٶԸ�ʴ��Ľ���������ͣ�ʹ���ԵԲ��
figure(4),imshow(I2);title('����ͼ��');%�������ͼ��
%��ԭʼͼ���뱳��ͼ������������ǿͼ��
I3=imsubtract(I1,I2);%����ͼ���
figure(5),imshow(I3);title('��ǿ�ڰ�ͼ��');%����ڰ�ͼ��
 
%Step3 ȡ�������ֵ����ͼ���ֵ�����˴�Ϊ���ֵ㷨��ȡ�Ҷȷ�Χ������֮����
fmax1=double(max(max(I3)));%I3�����ֵ�����˫������
fmin1=double(min(min(I3)));%I3����Сֵ�����˫������
T=(fmax1-(fmax1-fmin1)/3)/255;%��������ֵ

%bw22=im2bw(I3,T);%ת��ͼ��Ϊ������ͼ��
bw22=imbinarize(I3,T);
bw2=double(bw22);
figure(6),imshow(bw2);title('ͼ���ֵ��');%�õ���ֵͼ��
%%%%%%%%%%%%%%%  ���ƶ�λģ��  %%%%%%%%%%%%%%%%%%%%
%   ��ѧ��̬ѧ������г��ƴֶ�λ
%    ���ò�ɫ���ص�ͳ�ƣ�����ɨ��ķ�ʽʵ�ֳ��ƾ�ȷ��λ

%Step4 ���ƴֶ�λ���Եõ���ֵͼ����б�Ե���Ϳ��ղ�������������̬ѧ����
sideline=edge(bw2,'canny');%��canny��Ե�������ʶ���ֵ����ͼ���еı߽�
figure(7),imshow(sideline);title('Canny����ͼ���Ե��ȡ');%��ȡ����ʾ����Ե
bg1=imclose(sideline,strel('rectangle',[5,19]));%ȡ���κ�ģ�ı�����
figure(8),imshow(bg1);title('ͼ�������[5,19]');%����������ͼ��
bg3=imopen(bg1,strel('rectangle',[5,19]));%ȡ[5,19]���κ�ģ�Ŀ�����
figure(9),imshow(bg3);title('ͼ������[5,19]');%��ʾ��������ͼ��
bg2=imopen(bg3,strel('rectangle',[11,5]));%ȡ[11,5]���κ�ģ�Ŀ�����
%bg2=bwareaopen(bg2,);%����ϸС����
figure(10),imshow(bg2);title('ͼ������[11,5]');%��ʾ��������ͼ��
bg2=bwareaopen(bg2,5);%����ϸС�������������
%figure(11),imshow(bg2);title('����С����');
 
%Step5 ��������ɨ�裨��ɫ����Χ���壬����ɨ��ķ�ʽ������λ�;�����ֵ�ָ��
 
%%%%%%%%%%%%%%%%  Y���� %%%%%%%%%%%%%%%%
%��һ��ȷ��y����ˮƽ���򣩵ĳ�������
[y,x,z]=size(bg2);  %y�����Ӧ�У�x�����Ӧ�У�z�����Ӧ��ȣ�z=1Ϊ��ֵͼ��
myI=double(bg2);    %��������ת����ÿ������Χ��0~1  0Ϊ�ڣ�1Ϊ�ף���������
Im1=zeros(y,x);     %����һ����ͼ��һ����С�Ŀվ������ڼ�¼��ɨ��ʱ��ɫ���ص��λ��
Im2=zeros(y,x);     %����һ����ͼ��һ����С�Ŀվ������ڼ�¼��ɨ��ʱ��ɫ���ص��λ��
Blue_y=zeros(y,1);  %����һ��������������ͳ����ɨ��ĳ�е���ɫ���ص����


%��ʼ��ɨ�裬��ÿһ�����ؽ��з�����ͳ���������������������ж�Ӧ�ĸ�����ȷ�����Ƶ����±߽�
for i=1:y      %��ɨ��
   for j=1:x
        if  (myI(i,j,1)==1)      %��RGB��ɫģ���У�0��0��1����ʾ��ɫ��ת�����ݺ� 1Ϊ��ɫ���ڶ�ֵͼ����ɫ���ֳ���ɫ��Ҳ����1��i,jΪ���ꡣ
           Blue_y(i,1)=Blue_y(i,1)+1;%ͳ�Ƶ�i����ɫ���ص�ĸ���
           Im1(i,j)=1; %�����ɫ���ص��λ��
       end
   end
end
   
% Y����������ȷ��
[temp,MaxY]=max(Blue_y);
 
%��ֵ�������Ǿ��飬����ͳ�Ʒ��������ͳ��ƵĹ̶�����������ֵ���ڹ涨��С�ĳ���ͼ���ϳ�������ĳ�����ͳ�ƣ�������ĳ��ֵ
Th=5;  %��ֵ�����ɸģ�Ҫ��ȡ������ɫ��������ֵ��Χ��

%����׷�ݣ�ֱ�����������ϱ߽�
PY1=MaxY;
while((Blue_y(PY1,1)>=Th)&&(PY1>1))
    PY1=PY1-1;
end
 
%����׷�ݣ�ֱ������������±߽�
PY2=MaxY;
while((Blue_y(PY2,1)>=Th)&&(PY2<y))
    PY2=PY2+1;
end
 
%�Գ����������У�����ӿ򣬼��ٳ���������Ϣ��ʧ
PY1=PY1-2;
PY2=PY2+2;
if PY1<1
    PY1=1;
end
if PY2>y
    PY2=y;
end
 
%�õ���������
IY=I(PY1:PY2,:,:);
 
%%%%%%%%%  X���� %%%%%%%%%%%
%��һ��ȷ��x������ֱ���򣩵ĳ�������ȷ�����Ƶ����ұ߽�
Blue_x=zeros(1,x);   %����һ����������ͬ��ͳ����ɨ��ĳ�е���ɫ���ص����
%��ɨ�裬ȷ�����Ƶ����ұ߽�
for j=1:x     
    for i=PY1:PY2
           if  (myI(i,j,1)==1)
              Blue_x(1,j)=Blue_x(1,j)+1;  %ͳ�Ƶ�j����ɫ���ص�ĸ���
              Im2(i,j)=1; %�����ɫ���ص��λ��
           end
    end
end

%{
Blue_x=zeros(1,x);
for j=1:x
    for i=PY1:PY2
        if(myI(i,j,1)==1)
            Blue_x(1,j)=Blue_x(1,j)+1;
        end
    end
end

[maxcol,indexYmax]=max(Blue_x);
left=indexYmax;
Th=3;
while(Blue_x(1,left)>Th && left>0)
    left=left-1;
end
right=indexYmax;
while(Blue_x(1,right)>Th && right<x)
    right=right+1;
end
Tx=I(:,left:right,:);
%}

%����׷�ݣ�ֱ���ҵ�����������߽�
PX1=1;
Th1=3; %������ֵ��ѡȡ���ɸ�
while(Blue_x(1,PX1)<Th1)
    PX1=PX1+1;
end
%����׷�ݣ�ֱ���ҵ����������ұ߽�
PX2=x;
while(Blue_x(1,PX2)<Th1)
    PX2=PX2-1;
end
% �Գ����������У�����ӿ򣬼�����Ϣ��ʧ
PX1=PX1-2;
PX2=PX2+2;
if PX1<1
    PX1=1;
end
if PX2>x
    PX2=x;
end
 
%�õ���������
IX=I(:,PX1:PX2,:);
 
%�ָ������
Plate=I(PY1:PY2,PX1:PX2,:);
row=[PY1 PY2];
col=[PX1 PX2];
Im3=Im1+Im2;  %ͼ���������
Im3=logical(Im3);
Im3(1:PY1,:)=0;
Im3(PY2:end,:)=0;
Im3(:,1:PX1)=0;
Im3(:,PX2:end)=0;
%%%%% ��ʾ%%%%%
figure(11);
subplot(2,2,4);imshow(IY);title('�й��˽��','FontWeight','Bold');
subplot(2,2,2);imshow(IX);title('�й��˽��','FontWeight','Bold');
subplot(2,2,1);imshow(I);title('ԭͼ��','FontWeight','Bold');
subplot(2,2,3);imshow(Plate);title('��������','FontWeight','Bold');
imwrite(Plate,'Plate��ɫͼ.jpg');
Plate1=rgb2gray(Plate);%rgb2grayת���ɻҶ�ͼ
imwrite(Plate1,'Plate�Ҷ�ͼ.jpg');
%%Rando��бУ��
%plate=rando_bianhuan(Plate1);
plate=-1;
plate=imrotate(Plate1,plate,'bilinear','crop');%ȡֵΪ��ֵ������ת
%plate=houghbianhuan(Plate);
figure(12);
subplot(3,1,1);imshow(Plate);title('RGB������бУ��ǰ');
subplot(3,1,2);imshow(Plate1);title('�Ҷȳ�����бУ��ǰ');
subplot(3,1,3);imshow(plate);title('�Ҷȳ�����бУ����');
imwrite(plate,'PlateУ����ͼ��.jpg');