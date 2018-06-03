function CasicBP()
clc
close all

filepath = './letters_numbers/';
rand('state',0);

targets = [eye(36)];

for i = 1:10      %数字0-9
    imageP=imread(strcat(filepath,strcat(num2str((i-1)),'.bmp')));
    charvec = casic_imgresize(imageP);
    alphabet(:,i) = charvec;
end;
for i = 11:36     %字母26个
    imageP=imread(strcat(filepath,strcat(char(double('A')+i-11),'.bmp')));
    charvec = casic_imgresize(imageP);
    alphabet(:,i) = charvec;
end;

P=alphabet
T=targets

[R,Q] = size(P);
[S2,Q] = size(T);
S1 = 36;

%  创建一个新的前向神经网络  
net_1=newff(minmax(P),[S1,S2],{'tansig','logsig'},'traingdx');

%  当前输入层权值和阈值 
inputWeights=net_1.IW{1,1} 
inputbias=net_1.b{1} 

%  当前网络层权值和阈值 
% layerWeights=net_1.LW{2,1} 
% layerbias=net_1.b{2} 
net_1.LW{2,1}=net_1.LW{2,1}*0.01
net_1.b{2} =net_1.b{2}*0.01

%  设置训练参数
net_1.trainParam.show = 50; 
net_1.trainParam.lr = 0.05; 
net_1.trainParam.mc = 0.95; 
net_1.trainParam.epochs = 10000; 
net_1.trainParam.goal = 1e-3; 

%  调用 TRAINGDM 算法训练 BP 网络 进行第一次无噪声训练
[net_1,tr]=train(net_1,P,T); 

T=[targets targets targets targets];
% 噪声图像
%  设置训练参数
net_1.trainParam.show = 50; 
net_1.trainParam.lr = 0.05; 
net_1.trainParam.mc = 0.95; 
net_1.trainParam.epochs = 10000; 
net_1.trainParam.goal = 0.014; 
for pass=1:10
    P=[alphabet,alphabet];
    for i=1:R
        for j=1:Q
            if rand<=0.1
                alphabet1(R,Q)=0;
            else alphabet1(R,Q)=alphabet(R,Q);
            end;
        end;
    end;
    P=[P,alphabet1];
    for i=1:R
        for j=1:Q
            if rand<=0.1
                alphabet1(R,Q)=1;
            else alphabet1(R,Q)=alphabet(R,Q);
            end;
        end;
    end;
     P=[P,alphabet1];
    [net_1,tr]=train(net_1,P,T);
end

%  最后一次做无噪声训练，增加可靠性
%  设置训练参数
net_1.trainParam.show = 300; 
net_1.trainParam.lr = 0.05; 
net_1.trainParam.mc = 0.95; 
net_1.trainParam.epochs = 10000; 
net_1.trainParam.goal = 1e-4; 
P=alphabet;
T=targets;
[net_1,tr]=train(net_1,P,T);
%-------------------------训练完成后载入待处理图片-----------------------------------------
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.*'}, '读取噪声图像:');
imagen=imread([pathname,filename]);
%imagen=imread('./letters_numbers/E.bmp');
%imagen=imread('Test_5.JPG');
imshow(imagen);
title('读取噪声图像');

if size(imagen,3)==3 %RGB图像
    imagen=rgb2gray(imagen);
end

%转换为二值图像
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);
% 清除小于30像素的区域
imagen = bwareaopen(imagen,30);
figure;imshow(imagen);
word=[ ];
re=imagen;
%Opens text.txt as file for write
fid = fopen('text.txt', 'wt');

% 提取噪声图像中的字符图像
while 1
    [fl re]=lines(re);
    imgn=fl;
    figure;imshow(imgn)
    [L Ne] = bwlabel(imgn);    
    for n=1:Ne
        [r,c] = find(L==n);
        % Extract letter
        n1=imgn(min(r):max(r),min(c):max(c));  
        figure; imshow(n1);%将数字每一位进行分割
        % Resize letter (same size of template)
        %------------------------------------
        charvec = casic_imgresize(n1);
        [a,b]=max(sim(net_1,charvec));
        if(b<=10)
            %imageT=imread(strcat(filepath,strcat(num2str((b-1)),'.bmp')));
            letter=num2str(b-1);
        else
            %imageT=imread(strcat(filepath,strcat(char(double('A')+b-11),'.bmp')));
            letter=char(double('A')+b-11);
        end;
        %-------------------------------------
        % Letter concatenation
        word=[word letter];
    end
    %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
    fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
    % Clear 'word' variable
    word=[ ];
    %*When the sentences finish, breaks the loop
    if isempty(re)  %See variable 're' in Fcn 'lines'
        break
    end    
end
fclose(fid);
%Open 'text.txt' file
winopen('text.txt')
clear all



%其中涉及到的casic——imgresize程序见下：function lett = casic_imgresize(bw2)
% character representation in single vector.

bw_4224=imresize(bw2,[42,24]);
for cnt=1:42
    for cnt2=1:24
        %Atemp=sum(bw_7050((cnt*10-9:cnt*10),(cnt2*10-9:cnt2*10)));
        lett((cnt-1)*24+cnt2)=bw_4224(cnt,cnt2);
    end
end

lett=lett/100;
lett=lett';