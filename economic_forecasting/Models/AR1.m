clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);

MSFE_RW= 8.949053318210024e+03;
m=2;
data0=data(1:m);
data= data(m+1:end);
T=length(data);
T0=50;h=1;
data_AR1=zeros(T-h-T0+1,1);
for t=T0:T-h
    datat=data(h:t);
    yt=[[data0(m);data(1:t-h)]];
    betahat1=(yt'*yt)\(yt'*datat);
    data_AR1(t-T0+1,:)=[data(t)]*betahat1;
end

dataobs=data(T0+h:end);

MSFE_AR=mean((dataobs-data_AR1).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE_AR/MSFE_RW

plot(T0+h:T,data_AR1,T0+h:T,dataobs);