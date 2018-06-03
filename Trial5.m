%% 灰度图形态学运算
clc;close all;clear;
x=1:600;
y=2*sin(0.01*x)+sin(0.02*x)+sin(0.04*x);
SELen=51; % odd number
%SE=ones(1,SELen);
%% 腐蚀运算 
y_erosion=nan(size(y));
for i=1:length(y)
    h=max(1,i-floor(SELen/2));
    t=min(length(y),i+floor(SELen/2));
    y_erosion(i)=min(y(h:t));
end
%% 膨胀
y_dilation=nan(size(y));
for i=1:length(y)
    h=max(1,i-floor(SELen/2));
    t=min(length(y),i+floor(SELen/2));
    y_dilation(i)=max(y(h:t));
end
%% 开运算
y_open=y_erosion; % 先腐蚀后膨胀
for i=1:length(y_erosion)
    h=max(1,i-floor(SELen/2));
    t=min(length(y_erosion),i+floor(SELen/2));
    y_open(i)=max(y_erosion(h:t));
end
%% 闭运算
y_close=y_dilation; % 先膨胀后腐蚀
for i=1:length(y_dilation)
    h=max(1,i-floor(SELen/2));
    t=min(length(y_dilation),i+floor(SELen/2));
    y_close(i)=min(y_dilation(h:t));
end
figure;plot(x,y,'r-',x,y_erosion,'g-',x,y_dilation,'b-');
xlabel('点序号');ylabel('灰度值');legend('原曲线','腐蚀','膨胀');
figure;plot(x,y_open,'r-',x,y_close,'b-');
xlabel('点序号');ylabel('灰度值');
legend('开','闭');
