clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);
T=length(data);

Newdata=data(2:end)-data(1:end-1);

m=4;
Newdata0=Newdata(1:m);
Newdata= Newdata(m+1:end);
T=length(Newdata);
T0=50;h=5;
Newdata_AR=zeros(T-h-T0+1,1);
for t=T0:T-h
    Newdatat=Newdata(h:t);
    yt=[[Newdata0(m);Newdata(1:t-h)] [Newdata0(m-1:end);Newdata(1:t-h-1)]...
        [Newdata0(m-2:end);Newdata(1:t-h-2)]];
    betahat1=(yt'*yt)\(yt'*Newdatat);
    Newdata_AR(t-T0+1,:)=[Newdata(t) Newdata(t-1) Newdata(t-2)]*betahat1;
end
dataobs=Newdata(T0+h:end);
MFAE=mean(

sigmahat=(1/(length(data)-1))*sum((dataobs-Newdata_AR).^2);

Newdata_AR1=zeros(1,1);
for t=T
    Newdata1t=Newdata(h:t);
    y1t=[[Newdata0(m);Newdata(1:t-h)] [Newdata0(m-1:end);Newdata(1:t-h-1)]...
        [Newdata0(m-2:end);Newdata(1:t-h-2)]];
    betahat2=(y1t'*y1t)\(y1t'*Newdata1t);
    Newdata_AR1=[Newdata(t) Newdata(t-1) Newdata(t-2)]*betahat2;
end
Newdata_AR1
IntForecast1=[Newdata_AR1-1.645*sqrt(sigmahat) Newdata_AR1+1.645*sqrt(sigmahat) ]



