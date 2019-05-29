clc
clear all

%% Question2(i) regression analysis
y1=[log10(1964/50) log10(164/50) log10(14/50) log10(3/50)]; %lumda
x1=[3 4 5 6]; %magnitude
a=polyfit(x1,y1,1);
y2=[log(1964/50) log(164/50) log(14/50) log(3/50)]; %lumda in natural log
x2=[3 4 5 6]; %magnitude
b=polyfit(x2,y2,1); %b的前面項是m的係數

%% Question2(ii)
beta=-b(1);
dm=0.001;
m=3:dm:8;
f=beta*exp(-beta*(m-3)); %f is f(m), the probility of magnitude; m is magnitude
PMall=0;
for i=2:length(m)
    PMall=PMall+(f(i-1)+f(i))/2*dm;
end
n1=(5.5-3)/dm+1;
n2=(6.5-3)/dm+1;
PM=0;
for i=n1:n2
    PM=PM+(f(i-1)+f(i))/2*dm;
end
PMii=PM/PMall;
figure
plot(m,f)
xlabel('magnitude')
ylabel('f(m)')

%% Question2(iii)
beta=-b(1);
m=3:dm:6.5;
f1=(beta*exp(-beta*(m-3)))/(1-exp(-beta*(6.5-3))); %f1 is f(m), the probility of magnitude; m is magnitude
PMall1=0;
for i=2:length(m)
    PMall1=PMall+(f1(i-1)+f1(i))/2*dm;
end
n1=(5.5-3)/dm+1;
n2=(6.5-3)/dm+1;
PM1=0;
for i=n1:n2
    PM1=PM1+(f1(i-1)+f1(i))/2*dm;
end
PMiii=PM1/PMall1;
figure
plot(m,f1)
xlabel('magnitude')
ylabel('f(m)')
