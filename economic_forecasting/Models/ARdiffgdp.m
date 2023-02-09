%AR3 - 1 diff + GDP
clc
clear all
 
Data= xlsread('6202002');
 
y=Data(:,1);
T=length(y); 
t=(1:T)'; 
R=Data(:,4);
g=Data(:,5);
Newdata=data(2:end,1)-data(1:end-1,1);

 
m=4; % the first m points as lags
y0=y(1:m); y=y(m+1:end);T=length(y);
T0=50; h=1; %h step ahead forecast
yhatAR3=zeros(T-h-T0+1,1); %AR(3) forecast
 
 
for t=T0:T-h
    yt=y(h+1:t);
    gdp=lagmatrix(g,h);
    gdp=gdp(1:t);
    zt=[[y0(m);y(1:t-h)] [y0(m-1:end);y(1:t-h-1)] [y0(m-2:end);y(1:t-h-2)] gdp];
    zt=zt(1+h:t,:);
    betahat3 =(zt'*zt)\(zt'*yt);
    %store the forecasts
    yhatAR3(t-T0+1,:)=[y(t) y(t-1) y(t-2) g(t)]*betahat3;
end
ytph=y(T0+h:end); %observed y_{t+h}
 
MSFE_AR3=mean((ytph-yhatAR3).^2)