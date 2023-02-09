clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);


m=3;
data0=data(1:m);
data= data(m+1:end);
T=length(data);
T0=50;h=1;
data_AR2=zeros(T-h-T0+1,1);
for t=T0:T-h
    datat=data(h:t);
    yt=[[data0(m);data(1:t-h)] [data0(m-1:end);data(1:t-h-1)]];
    betahat2=(yt'*yt)\(yt'*datat);
    data_AR2(t-T0+1,:)=[data(t) data(t-1)]*betahat2;
end
dataobs=data(T0+h:end);
MSFE_AR2=mean((dataobs-data_AR2).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE_AR2/MSFE_RW

plot(T0+h:T,data_AR,T0+h:T,dataobs);