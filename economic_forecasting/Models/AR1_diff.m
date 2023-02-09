clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);
T=length(data);

Newdata=data(2:end)-data(1:end-1);

m=2;
Newdata0=Newdata(1:m);
Newdata= Newdata(m+1:end);
T=length(Newdata);
T0=50;h=1;
Newdata_AR=zeros(T-h-T0+1,1);
for t=T0:T-h
    Newdatat=Newdata(h:t);
    yt=[ones(t-h+1,1) [Newdata0(m);Newdata(1:t-h)]];
    betahat1=(yt'*yt)\(yt'*Newdatat);
    Newdata_AR(t-T0+1,:)=[1 Newdata(t)]*betahat1;
end
dataobs=Newdata(T0+h:end);
MSFE_AR=mean((dataobs-Newdata_AR).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE_AR/MSFE_RW

plot(T0+h:T,Newdata_AR,T0+h:T,dataobs);