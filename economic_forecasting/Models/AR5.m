clear all
clc

data=xlsread('labor','Data1');
data=data(6:end,3);

m=6; 
data0=data(1:m); 
data=data(m+1:end);
T=length(data);
T0=50; h=1; 
data_AR5=zeros(T-h-T0+1,1); 
 
for t=T0:T-h
    datat=data(h:t);
    yt=[[data0(m);data(1:t-h)] [data0(m-1:end);data(1:t-h-1)] [data0(m-2:end);data(1:t-h-2)]...
        [data0(m-3:end);data(1:t-h-3)] [data0(m-4:end);data(1:t-h-4)]];
    betahat5 =(yt'*yt)\(yt'*datat);
    data_AR5(t-T0+1,:)=[data(t) data(t-1) data(t-2) data(t-3) data(t-4)]*betahat5;
end
data_obs=data(T0+h:end);
 
MSFE_AR5=mean((data_obs-data_AR5).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE_AR5/MSFE_RW

plot(T0+h:T,data_AR5,T0+h:T,data_obs);