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
T0=460;h=1;
Newdata_AR=zeros(1,1);
for t=T
    Newdatat=Newdata(h:t);
    yt=[[Newdata0(m);Newdata(1:t-h)] [Newdata0(m-1:end);Newdata(1:t-h-1)]...
        [Newdata0(m-2:end);Newdata(1:t-h-2)]];
    betahat1=(yt'*yt)\(yt'*Newdatat);
    Newdata_AR=[Newdata(t) Newdata(t-1) Newdata(t-2)]*betahat1;
end

dataobs=Newdata(T0+h:end);
MSFE_AR=mean((dataobs-Newdata_AR).^2);
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE_AR/MSFE_RW



