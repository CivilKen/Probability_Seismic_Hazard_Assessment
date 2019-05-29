clc
clear all

% read earthquake data 
fid = fopen('TCU076.V2','r');
tline = fgetl(fid);
col = 1; % stand for which row to fill in
allData = zeros(9,15000); %�Ҧ���Ʀs��all data�̭�(�ϥ�cell���O)
while ischar(tline)
   
   matchesa1 = strfind(tline,'points of accel'); 
   numa1 = length(matchesa1); %�P�_���L�ŦXaccl���r��
   if numa1 > 0 %��Ū��accl���r��
      %fprintf(1,'%d:%s\n',numa,tline);
      
      A=fscanf(fid,'%f');
      allData(col,1:15001) = A;
      col=col+1;
   end
      
   matchesv1 = strfind(tline,'points of veloc');
   numv1 = length(matchesv1); %�P�_���L�ŦXveloc���r��
   if numv1 > 0 %��Ū��veloc���r��
      %fprintf(1,'%d:%s\n',numv,tline);
      
      V=fscanf(fid,'%f');
      allData(col,1:15001) = V;
      col=col+1;
   end
      
   matchesd1 = strfind(tline,'points of displ');
   numd1 = length(matchesd1); %�P�_���L�ŦXdispl���r��
   if numd1 > 0 %��Ū��displ���r��
      %fprintf(1,'%d:%s\n',numd,tline);
      
      D=fscanf(fid,'%f');
      allData(col,1:15000) = D;
      col=col+1;
   end   
   
   
   tline = fgetl(fid); %�AŪ�U�@��  
   
end
fclose(fid);

t = 0:0.01:149.99;
A1 = allData(1,1:15000);
V1 = allData(2,1:15000);
D1 = allData(3,1:15000);
A2 = allData(4,1:15000);
V2 = allData(5,1:15000);
D2 = allData(6,1:15000);
A3 = allData(7,1:15000);
V3 = allData(8,1:15000);
D3 = allData(9,1:15000);

% HW4(Frourier Spectrum)
 af=fft(A3); %after Fourier Trasformed but not revised
 afshift=fftshift(af); %after Fourier Trasformed and revised
 amp=abs(afshift)/length(afshift); %true amplitude
 phase=angle(afshift);
 
 fnyq=1/(2*0.01); %fnyq=1/(2*dt) Nyquist frequency
 df=1/(0.01*15000);
 frequency=-fnyq:df:fnyq-df;
 Amp=amp(6000:9000);
 Phase=phase(6000:9000);
 Frequency=frequency(6000:9000);
 
 %graphics
 figure
 plot(Frequency,Amp)
 figure
 plot(Frequency,Phase)
 
 ampsf=(amp.^2)./frequency;
 AMPSF(1)=ampsf(1);
 for j=2:n
    AMPSF(j)=(AMPSF(j-1)+ampsf(j));
end
 amps=amp.^2;
 AMPS(1)=amps(1);
 for i=2:n
    AMPS(i)=(AMPS(i-1)+amps(i));
end
 Tm=AMPSF/AMPS;