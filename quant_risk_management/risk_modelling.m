close all
clear all
clc

%Matrix "data" is for the whole period: 05/1991 to 05/2016-->729 stocks
data=xlsread('QRMData');
data=data(:,all(~isnan(data)));  
size(data);
%Matrix "last_decade" is for the last 10 years: 05/2006 to 05/2016-->1611 stocks

 %sample returns and sample covariance matrix (I will use data of the whole   )
       
for i=1:181
    sample_returns=((data(i+1:120+i,:)-(data(i:119+i,:)))./(data(i:119+i,:)));
    MU=((1+mean(sample_returns)).^12)-1;
    MU=MU';
    sample_covariance=cov(sample_returns);
    SIGMA=sample_covariance.*sqrt(12);

   
    %Portfolio Optimization assuming RF=.03 (we will have to substract before
    %and work with excess returns if we have a time-dependent risk free rate!!
    RF=0.03;
    %GMVP
    N=size(MU,1);
    PHI=ones(1,N);
    q=1;
    w_GMVP=inv(SIGMA)*PHI'*inv(PHI*inv(SIGMA)*PHI')*q;
    SD_GMVP=(w_GMVP'*SIGMA*w_GMVP)^0.5;
    MU_GMVP=w_GMVP'*MU;
    SR_GMVP=(MU_GMVP-RF)/SD_GMVP;

    %MSR
    MU_ER=MU-RF.*ones(N,1);
    w_MSR=(inv(SIGMA)*MU_ER)./(PHI*inv(SIGMA)*MU_ER);
    SD_MSR=(w_MSR'*SIGMA*w_MSR)^0.5;
    MU_MSR=w_MSR'*MU;
    SR_MSR=MU_MSR/SD_MSR;
    
    NEWDATA(:,i) = w_GMVP;    
end

%average return for out of sample analysis in the mean-variance framework
out_of_sample=data(120:301,:);
out_of_sample_returns=(out_of_sample(2:end,1:729)-out_of_sample(1:end-1,1:729))./out_of_sample(1:end-1,1:729);
MU1=((1+mean(out_of_sample_returns)).^12)-1;
mean(MU1)
vol_returns=std(out_of_sample_returns).*sqrt(12);
SR = MU1./vol_returns
mean(SR)

ultimate_returns=NEWDATA'.*out_of_sample_returns*100;
A=mean(ultimate_returns)
vol_returns1=std(ultimate_returns);
SR_each=A./vol_returns1;
Average_return_all=mean(A);
Average_SR_all=mean(SR_each);

%%
%Now, we have to see the out-of-sample results of these two portfolios and
    %compute several performance & risk measures: Distribution of the returns, variance, 
    %Skewness, Kurtosis, Value at Risk, Expected Shortfall, Worst Historical Drawdown,
    %correlations between the assets (correlations in the worst 1% and 5%
    %scenarios)-->It gives a frist view of tail dependence 
    
%Do the returns of one stock to test
data1=data(:,1);
data2=data(:,2);
ret=(data1(2:end)-data1(1:end-1))./data1(1:end-1);
ret2=(data2(2:end)-data2(1:end-1))./data2(1:end-1);
pdf1=fitdist(ret,'Normal')
pdf2=fitdist(ret2,'Normal')
%--------DESCRIPTIVE STATISTICS--------------
%Distribution of the returns
figure
hist(ret,50)
%Moments
mean(ret)% mean
std(ret)% standard deviation
skewness(ret)% skewness
kurtosis(ret)% kurtosis
%Empirical VaR (sorting and finding the quantile)
size(ret)
sorted_ret=sort(ret);
sorted_ret(4)/2+sorted_ret(3)/2
(sorted_ret(15)+sorted_ret(16))/2
(sorted_ret(30)+sorted_ret(31))/2
Hist_q=quantile(ret,0.01)
Hist_q=quantile(ret,0.05)
Hist_q=quantile(ret,0.1)
%Worst Historical Drawdown
sorted_ret(1)
%Empirical Expected Shortfall
mean(sorted_ret(1:4))
mean(sorted_ret(1:16))
mean(sorted_ret(1:31))
%Tail Dependence (need the portfolio tot do it)



    
 
