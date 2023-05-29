%Capa vs Eb/N0 - linear sacle
EsN0dB=(-100:30);
EsN0=10.^(EsN0dB/10);
ShannonCapacity=log2(1+EsN0);

figure
plot(EsN0dB-10*log10(ShannonCapacity),log2(1+EsN0));
hold on 
plot([-1.59,-1.59+eps],[0, 10],'r--');

grid on

xlabel('E_b/N_0')
ylabel('bit per channel use')