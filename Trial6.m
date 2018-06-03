close all;clear;

I=imread('rgb_plant.jpg');%��ȡͼ��
figure(1); 
subplot(2,2,1);%��ͼһ��Ϊ�Ŀ飬ͼһ�ĵ�һ��ͼF:\workspace\MathModel\recognize
 
imshow(I), title('��ȡ���ƺ�ͼ��'); 
%%%%%%%%%%��ֵ��ͼ��
%%%%%%%% 
I1 = rgb2gray(I);%��ɫͼ��ת��Ϊ�Ҷ�ͼ��
 
h=graythresh(I1);  
%I1=im2bw(I1,h);%���Ҷ�ͼ���ֵ��
I1=imbinarize(I1,h);
figure(1);  
subplot(2,2,2);%ͼһ�ĵڶ���ͼ

% I1=imread('binary_plant.jpg');
imshow(I1),title('���ƶ�ֵ����ͼ��'); 
 
%%%%%%%%%%%%ȥ������
%%%%%%%%%%%% 
[y,~,~]=size(I1);%����I1�Ĵ�С
  
%%%%%%%%%��ͼ����п�������
%%%%%%%% 
SE=strel('disk',fix(y/45));%����һ��ƽ̹��Բ���νṹԪ��
 I2=imopen(I1,SE);%ȡԲ���εĿ����� subplot(2,2,3);%ͼһ�ĵ�����ͼ
 
imshow(I2),title('I2�������ͼ��');
SE=strel('diamond',fix(y/140));%����һ��ƽ̹�����νṹԪ��
I3=imclose(I2,SE);%ȡ���νṹ�ı����� subplot(2,2,4);%ͼһ�ĵ��ķ�ͼ
 
imshow(I3),title('I3�������ͼ��'); I4=double(I3);%��Ϊ˫����
  
%%%%%%%%%%%%%%%��������
%%%%%%%%%%%%%%% 
%%%%%%%����������
%%%%%%%% 
Y1=sum(I1,2);
% figure(2);  
% plot(Y1,0:y-1),title('�з������ص�Ҷ�ֵ�ۼƺ�'),xlabel('�ۼ�������'),ylabel('��ֵ'); 
%%%%%ȥ���з���߿�
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

Z1=I1(Py0:Py1,:,:);%����ֵͼ�����±߿�ȥ��
 
figure(3);  
imshow(Z1),title('����ֵͼ�����±߿�ȥ����ͼ��');%����ֵͼ�����±߿�ȥ����ͼ����ʾ��
  
[y,x,z]=size(Z1);%�����ʱͼ��Ĵ�С

%%%%%%%%%%%%����������
%%%%%%%%%% 
X1=sum(Z1,1);


figure(4);  
plot(0:x-1,X1),title('�з������ص�Ҷ�ֵ�ۼƺ�'),xlabel('��ֵ'),ylabel('�ۼ�������'); 
%%%%%%%%ȥ����ֱ�߿�
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
Z2=Z1(:,x0:x1,:);%����ֵͼ�����ұ߿�ȥ��
figure(5);
imshow(Z2),title('����ֵͼ��ֱ�߿�ȥ����ͼ��');%����ֵͼ��ֱ�߿�ȥ����ͼ����ʾ����
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
%%%%%%%%%�ٴμ����з�������
%%%%%%%%% 
[y,x,z]=size(Z2);%�����ʱͼ��Ĵ�С
X1=zeros(1,x); 
for j=1:x 
    for i=1:y  
        if(Z2(i,j,1)==1) 
            X1(1,j)= X1(1,j)+1;%����I3��j���м���һ
        end 
    end 
end  
%%%%%%%ȥ��Բ��
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
imshow(Z2),title('ȥ��Բ���ͼ��');  
%%%%%%%%%%%%%��ͼ��ָ�
%%%%%%%%%%%%%% 
y=fix(x*90/409);  
%%%%%%%��ͶӰ���ָ�
%%%%%% 
for i=1:7  
    while ((X1(1,Px0)<10)&&(Px0<x))  
        Px0=Px0+1;%�ҵ����ָ��ַ���ߵ�λ��
    end 
    Px1=Px0; 
    a=1;  
    while (((X1(1,Px1)>=10)&&(Px1<x))||((Px1<x)&&((a/y)<=0.5))) 
        Px1=Px1+1;%�ҵ����ָ��ַ��ұߵ�λ��
        a=Px1-Px0; 
    end  
    Z3=Z2(:,Px0:Px1,:);%��ֵ��ͼ��ָ��
    figure(7); 
    subplot(1,7,i);   
    imshow(Z3);%����ֵ��ͼ��ָ����ʾ����
    %%�任Ϊ��׼��ͼ
 
    Z4=imresize(Z3,[88 40]);%���ָ��Ķ�ֵͼ�任Ϊ��׼��ͼ
    figure(8); 
    subplot(1,7,i);  
    imshow(Z4),title('��׼��ͼ');%����׼��ͼ��ʾ����
    Px0=Px1; 
end  
%}
