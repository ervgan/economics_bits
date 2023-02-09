clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);
T=length(data);



%one-step ahead forecasts historical mean and random walk
h=1; T0=2;
datahat_h=zeros(T-h-T0+1,1);
datahat_r=zeros(T-h-T0+1,1);
data_obs=data(T0+h:end);
for t=T0:T-h
    datat=data(1:t);
    datahat_r(t-T0+h,:)=datat(end);
    datahat_h(t-T0+h,:)=mean(datat);
end
MSFE_RW=mean((data_obs-datahat_r).^2)
MSFE_h=mean((data_obs-datahat_h).^2)

plot(1:T,data);
print -depsc myfig.eps

plot(T0+h:T,data_obs,T0+h:T,datahat_r,T0+h:T,datahat_h);






