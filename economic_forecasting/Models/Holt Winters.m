%HOLT WINTERS 1 STEP AHEAD MONTHLY 
clc
clear all
 
data=xlsread('data');
y=data(:,1);

T=length(data);
t=(1:T)';
 
T0 = 50; h = 1; s=12;
syhat = zeros(T-h-T0+1,1);
ytph = y(T0+h:end); % observed y {t+h}
alpha = .2; beta = .2; gamma=.2;% smoothing parameters
St=zeros(T-h,1);
Lt = mean(y(1:s)); bt = 0; St(1:12)=y(1:s)/Lt
for t = s+1:T-h
newLt = alpha*(y(t)-St(t-s)) + (1-alpha)*(Lt+bt);
newbt = beta*(newLt-Lt) + (1-beta)*bt;
St(t)=gamma*(y(t)-newLt) + (1-gamma)*St(t-s);
yhat = newLt + h*newbt + St(t+h-s);
Lt = newLt; bt = newbt; % update Lt and bt
if t>= T0 % store the forecasts for t >= T0
syhat(t-T0+1,:) = yhat;
end
end

sigmahat=(1/(T-1))*sum((ytph-syhat).^2)
11918892-11869102 

MAFE= mean(abs(ytph-syhat))
MSFE1 = mean((ytph-syhat).^2)
MSFE_RW= 8.949053318210024e+03;
RelMSE=MSFE1/MSFE_RW

plot(T0+h:T,ytph,T0+h:T,syhat)
