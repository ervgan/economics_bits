clear all
clc
 
 
data=xlsread('data');
y=data(:,1);
g=data(:,3);
T=length(y); 
t=(1:T)'; 

Q=data(:,4);
R=data(:,2);
T0=50;
 
%% construct 4 dummy vairables
D1=(Q==1); D2=(Q==2);
D3=(Q==3); D4= (Q==4);
%% construct 12 dummy variables
B1=(R==1); B2=(R==2); B3=(R==3);
B4=(R==4); B5=(R==5); B6=(R==6);
B7=(R==7); B8=(R==8); B9=(R==9);
B10=(R==10); B11=(R==11); B12=(R==12);

%S3, 1 step ahead forecast
h=1;
syhat=zeros(T-h-T0+1, 1);
ytph=y(T0+h:end);%observed y_{t+h}
for t=T0:T-h
    yt=y(1:t);
    yt=yt(h+1:t, :);
    D1t=D1(1:t); D2t=D2(1:t);
    D3t=D3(1:t); D4t=D4(1:t);
    gdp=lagmatrix(g(1:t),h);
    Xt=[lagmatrix((1:t),h) D1t D2t D3t D4t gdp];
    Xt=Xt(h+1:t, :);
    beta=(Xt'*Xt)\(Xt'*yt);
    yhat=[t+h D1(t+h) D2(t+h) D3(t+h) D4(t+h) gdp(t)]*beta;
    syhat(t-T0+1)=yhat;
end
MSFE1=mean((ytph-syhat).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE1/MSFE_RW

 



