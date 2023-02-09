clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);

m=4; % the first m points as lags
data0=data(1:m); data=data(m+1:end);T=length(data);
T0=50; h=1; %h step ahead forecast
data_AR3=zeros(T-h-T0+1,1); %AR(3) forecast
 
 
for t=T0:T-h
    datat=data(h:t);
    yt=[[data0(m);data(1:t-h)] [data0(m-1:end);data(1:t-h-1)] [data0(m-2:end);data(1:t-h-2)]];
    betahat3 =(yt'*yt)\(yt'*datat);
    %store the forecasts
    data_AR3(t-T0+1,:)=[data(t) data(t-1) data(t-2)]*betahat3;
end
data_obs=data(T0+h:end); %observed y_{t+h}
 
MSFE_AR3=mean((data_obs-data_AR3).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE_AR3/MSFE_RW

