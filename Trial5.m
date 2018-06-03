%% �Ҷ�ͼ��̬ѧ����
clc;close all;clear;
x=1:600;
y=2*sin(0.01*x)+sin(0.02*x)+sin(0.04*x);
SELen=51; % odd number
%SE=ones(1,SELen);
%% ��ʴ���� 
y_erosion=nan(size(y));
for i=1:length(y)
    h=max(1,i-floor(SELen/2));
    t=min(length(y),i+floor(SELen/2));
    y_erosion(i)=min(y(h:t));
end
%% ����
y_dilation=nan(size(y));
for i=1:length(y)
    h=max(1,i-floor(SELen/2));
    t=min(length(y),i+floor(SELen/2));
    y_dilation(i)=max(y(h:t));
end
%% ������
y_open=y_erosion; % �ȸ�ʴ������
for i=1:length(y_erosion)
    h=max(1,i-floor(SELen/2));
    t=min(length(y_erosion),i+floor(SELen/2));
    y_open(i)=max(y_erosion(h:t));
end
%% ������
y_close=y_dilation; % �����ͺ�ʴ
for i=1:length(y_dilation)
    h=max(1,i-floor(SELen/2));
    t=min(length(y_dilation),i+floor(SELen/2));
    y_close(i)=min(y_dilation(h:t));
end
figure;plot(x,y,'r-',x,y_erosion,'g-',x,y_dilation,'b-');
xlabel('�����');ylabel('�Ҷ�ֵ');legend('ԭ����','��ʴ','����');
figure;plot(x,y_open,'r-',x,y_close,'b-');
xlabel('�����');ylabel('�Ҷ�ֵ');
legend('��','��');
