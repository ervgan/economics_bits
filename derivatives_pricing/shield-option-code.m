clear all
close all
clc

% we have to estimate the market price of risk
% theta = long term mean-(sigma*market price of risk)/speed of mean reversion
% want to determine parameter Risk which is our theta 

% parameters
v = 4.52; % historical volatility (direclty put the number so no need to load data)
ko=0.3; % speed of mean reversion
k=1.1; % lower bound credit rating where 1=default
r=0.002; % risk free
T=5; % maturity
Risk=10; % theta, the parameter we want to determine (test multiple values)
b=1; % credit rating 1=default 
a=22; % credit rating 22=AAA
cds=[2.6 3 3.5 7 10 14 18 22]; % cds spread(+rf) for different credit ratings
bi=[22 17 15 13 11 9 5 3]; % different credit ratings

for i=1:8
	Ro = bi(i);
	% price x of a bond that pays 100 if no default
	denom=(a - Ro) * (Ro - b) * sqrt(T);
	first=log(Ro/k);
	sec=(1/Ro)*ko*(Risk-Ro);
	third= (1/(2*Ro^2))*(((a-Ro)^2) * ((Ro - b)^2))/(v^2);

	N=normcdf((v*T*(first+sec-third))/denom); %formula based on closed-form solution in report
	x=100*exp(-r*T)*(N); 

	y=(log(100/x))/T; % yield of bond paying 100 if no default

	ji(i)=y*100;
	FIN(i)=(ji(i)-cds(i))^2; % squared differences between our yield and cds spread (+risk free) 
	% of the same credit rating

	A=sum(FIN); % sum of squared differences 
	%(A needs to be the smallest out of all values of theta (risk) tested)
end


%% THE FOLLOWING CODE IS ONLY DONE FOR ONE INITIAL INDUSTRY RATING AS AN EXAMPLE
%Here, Initial rating = 19 but the pricing and simulations are done for all
%initial ratings in this project

% euler discretization  
mat = 0.25;
N = 100;        % Number of simulations.
count = (1:N)';
offset = 10;    % don't take into account first time steps, increase dispersion
T = 60;         % Number of months within 5 years
dt = mat/T;      % Time increment
SE = zeros(N,T);          

% Set starting credit rating for each path
SE(:,1) = 19; %(here initial rating =19 but have to simulate...
%for all initial credit values from 4 to 22)
rng('shuffle'); 

for n=1:N
	for t=2:T
		Z = randn(1); 
		W = sqrt(dt)*Z;
		% Euler discretization of stock price
		SE(n,t) = SE(n,t-1) + 0.3*(10-SE(n,t-1))*dt + (22-SE(n,t-1))*(SE(n,t-1)-1.1)*W/4.52;	
   	end
end

plot(SE');

%% 21 PRICES without down and out barriers (maturity 5 years) for each initial credit rating 

yield=[21.3 18.72 16.28 15.24 13.05 11.23 10.52 10.02 9.57 8.23 6.92 5.41 5.03 4.71 ...
    4.45 4.42 4.21 4.09 3.78 3.69 3.6]; %corporate bond yield for each credit rating

SE1=SE(:,60); % simulations of the last period

Ratings = round(SE1); %round up numbers to get round credit ratings numbers 

%volatility somteimes put the process obove the upper boundary 22 so this
%loop is to put equal to zero all ratings above 22
for i=1:60
    if Ratings(i) >= 22
        Ratings(i) = 0;
    end
end
Ratings = nonzeros(Ratings);


%get yields correspondings to ratings where there are payoffs (when ratings
%at the end of the period are below initial rating, otherwise, yield=0
N = size(Ratings,1);
YieldRatings = zeros(N,1); %initialization
for i=1:N
	a = Ratings (i);
    	YieldRatings(i,1) = 0;
 	if a < 19 %put yields of ratings above or equal to ...
	%initial rating equal to zero since no payoff in this case
    	YieldRatings(i,1) = yield(a);
   	end
end

Payoffs = YieldRatings-yield(19); %yield spread is the difference between ...
%yields of ratings at the end of period and the yield corresponding to
%initial rating

%Payoffs sometimes negative when the yield is zero in the vector
%YieldRatings so we want to put these negative yields equal to zero
for i=1:N 
    if Payoffs (i,1) < 0
    	Payoffs (i,1) = 0;
    end
end

Price =exp(-0.002*mat)*mean(Payoffs) %Price of the derivative if initial ...
%credit rating = 19 (AA)

%% Prices with barriers (only done for one initial industry rating and one...
%down and out barrier 13 in this code) 

for i=1:N
	a = Ratings (i);
	YieldRatings1(i,1) = 0;
	if a < 19
	   if a >= 13  %down and out barrier fixed at 13(BBB)
	    YieldRatings1(i,1) = yield(a);
	   end
	end
end


Payoff_barrier = YieldRatings1-yield(19);
for i=1:N 
    if Payoff_barrier(i,1) < 0
        Payoff_barrier(i,1) = 0;
    end
end
Price_barrier =exp(-0.002*mat)*mean(Payoff_barrier)







