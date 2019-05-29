clear all
clc

fid = fopen('TCU076.V2','r');
tline = fgetl(fid);
col = 1; % stand for which row to fill in
allData = zeros(9,15000); %所有資料存到all data裡面(使用cell指令)
while ischar(tline)
   
   matchesa1 = strfind(tline,'points of accel'); 
   numa1 = length(matchesa1); %判斷有無符合accl之字串
   if numa1 > 0 %有讀到accl之字串
      %fprintf(1,'%d:%s\n',numa,tline);
      
      A=fscanf(fid,'%f');
      allData(col,1:15001) = A;
      col=col+1;
   end
      
   matchesv1 = strfind(tline,'points of veloc');
   numv1 = length(matchesv1); %判斷有無符合veloc之字串
   if numv1 > 0 %有讀到veloc之字串
      %fprintf(1,'%d:%s\n',numv,tline);
      
      V=fscanf(fid,'%f');
      allData(col,1:15001) = V;
      col=col+1;
   end
      
   matchesd1 = strfind(tline,'points of displ');
   numd1 = length(matchesd1); %判斷有無符合displ之字串
   if numd1 > 0 %有讀到displ之字串
      %fprintf(1,'%d:%s\n',numd,tline);
      
      D=fscanf(fid,'%f');
      allData(col,1:15000) = D;
      col=col+1;
   end   
   
   
   tline = fgetl(fid); %再讀下一行  
   
end
fclose(fid);

t = 0:0.01:149.99;
A1 = allData(1,1:15000);  %unit:cm/s2
V1 = allData(2,1:15000);  % cm/s
D1 = allData(3,1:15000);  % cm
A2 = allData(4,1:15000);
V2 = allData(5,1:15000);
D2 = allData(6,1:15000);
A3 = allData(7,1:15000);
V3 = allData(8,1:15000);
D3 = allData(9,1:15000);
n=length(A3);

figure
plot(t,A3)  % oringinal time history of acceleration in EW direction
title('time history of acceleration')
xlabel('time(s)')
ylabel('accelration(cm/s2)')

%% Question 1(i)
dt=0.01;
gravity=9.81*100; % unit:cm/s2
AS3=A3.^2; % unit:cm2/s4, acc. of E-W direction
ia(1)=pi/(2*gravity)*(0+AS3(1))/2*dt; %還沒積分ㄉ值
for i=2:n  %n is the length of A3
    ia(i)=pi/(2*gravity)*(AS3(i-1)+AS3(i))/2*dt;
end
IA(1)=ia(1);
for ii=2:n
    IA(ii)=IA(ii-1)+ia(ii);
end
MaxIA=max(IA);
NIA=IA./MaxIA;
t005=find(NIA<0.05, 1, 'last' );
t075=find(NIA>0.75, 1 );
t095=find(NIA>0.95, 1 );
SD575=t(t075)-t(t005); %significant duration 5%-75%
SD595=t(t095)-t(t005); %significant duration 5%-95%
figure
plot(t,IA)
xlabel('time(s)')
ylabel('IA(cm.s)')

%% Question 1(ii)
 af=fft(A3); %after Fourier Trasformed but not revised
 afshift=fftshift(af); %after Fourier Trasformed and revised
 amp=abs(afshift); %Fourier amplitude
 phase=angle(afshift);
 
 fnyq=1/(2*dt); %fnyq=1/(2*dt) Nyquist frequency
 df=1/(dt*n);
 frequency=-fnyq:df:(fnyq);
 %amplitude during the frequency between -10 and 10 hz
 n10hz=find(frequency==(-10), 1, 'last' );
 p10hz=find(frequency==(10), 1 );
 Amp=amp(n10hz:p10hz)/length(afshift); 
 Phase=phase(n10hz:p10hz);
 Frequency=frequency(n10hz:p10hz);
 % min(find(frequency==(10))) represent the index at 10 Hz
 % max(find(frequency==(-10))) represent the index at -10 Hz
 
 %graphics
 figure
 plot(Frequency,Amp)
 title('Fourier Amplitude Spectrum')
 xlabel('frequency')
 ylabel('Fourier Amplitude(cm/s)')
 figure
 plot(Frequency,Phase)
 title('Fourier Phase Spectrum')
 xlabel('frequency')
 ylabel('Phase(rad)')
 
%% Question 1(iii) 
 %note:take the amplitude of frequency between 0.25 and 10 Hz
 i025hz=find(frequency<=0.25, 1, 'last' );
 i20hz=find(frequency>=20, 1 );
 frequency1=frequency(i025hz):df:frequency(i20hz);
 amp1=amp(i025hz:i20hz);
 n1=length(amp1);
 
 ampsf=(amp1.^2)./frequency1;
 AMPSF(1)=ampsf(1);
 for j=2:n1
    AMPSF(j)=(AMPSF(j-1)+ampsf(j));
end
 amps=amp1.^2;
 AMPS(1)=amps(1);
 for jj=2:n1
    AMPS(jj)=(AMPS(jj-1)+amps(jj));
end
 Tm=AMPSF/AMPS;  %mean period of acceleration
 
%% Question 1(iv)
ip1hz=find(frequency<1, 1, 'last' );
ip2hz=find(frequency>2, 1 );
in1hz=find(frequency>(-1), 1 );
in2hz=find(frequency<(-2), 1, 'last' );
ampp12=3*afshift(ip1hz:ip2hz);
ampn12=3*afshift(in2hz:in1hz);
afshift1=[afshift(1:in2hz-1),ampn12,afshift(in1hz+1:ip1hz-1),ampp12,afshift(ip2hz+1:length(afshift))];
AA3=ifft(afshift1);
figure
plot(t,AA3)
title('time history of acceleration')
xlabel('time(s)')
ylabel('accelration(cm/s2)')