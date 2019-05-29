clc
clear all

%% Question3 (i)
dm=0.01;
m0=5;
mu=6.9;
m=m0:dm:mu;
beta=log(10)*0.9;
f=(beta*exp(-beta*(m-m0)))/(1-exp(-beta*(mu-m0)));
figure
plot(m,f)
xlabel('magnitude')
ylabel('f(m)')

area=trapz(m,f) %taking smaller dm will lead to accurate area(1)

%% Question3 (ii)
M0=10.^(1.5*m+16.1)*10^(-7); %moment release(N*m)
mr=f.*M0;
MR=0;
for i=2:length(mr)  %the intergral of moment release
    MR=MR+(mr(i-1)+mr(i))/2*dm;
end
MBU=3*10^(10)*70*20*10^(6)*0.001; %rate of moment build-up, unit:N*m
lumda=MBU/MR;

%% Question3 (iii)
mu1=mu-0.5;
m1=m0:dm:mu1;
f1=(beta*exp(-beta*(m1-m0)))/(1-exp(-beta*(mu-m0)));
area1=trapz(m1,f1)
delta=1/1.9*(area1-1+0.5*(beta*exp(-beta*(5.4-m0)))/(1-exp(-beta*(mu-m0))));
ff=f-delta; % only for magnitude during 5 and 6.4
for i=1:length(m)
    if m(i)<6.4
        FF(i)=ff(i);
    elseif m(i)>=6.4
            FF(i)=ff(41);
    end
end
figure
plot(m,FF)  % FF represents the probility desity of Characteristic earthquake model 
xlabel('magnitude')
ylabel('f(m)')

%% Question3 (iv)
lumdac=0.00099;
M0=10.^(1.5*m+16.1)*10^(-7); %moment release
mr1=FF.*M0;
MR1=0;
imu=find(m>mu1, 1 );
for i=2:(imu-1)  %the intergral of moment release
    MR1=MR1+(mr1(i-1)+mr1(i))/2*dm;
end
MR2=0;
for i=imu:length(mr1)  %the intergral of moment release
    MR2=MR2+(mr1(i-1)+mr1(i))/2*dm;
end
MBU1=lumda*MR1+lumdac*MR2;

%% Question3 (v)
lumdam0=MBU/MBU1;
