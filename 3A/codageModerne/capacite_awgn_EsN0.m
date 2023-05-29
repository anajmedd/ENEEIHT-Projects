EsN0dB=(-10:30);
EsN0=10.^(EsN0dB/10);
ShannonCapacity=log2(1+EsN0);

%Capa vs SNR - linear scale
figure
plot(EsN0dB,ShannonCapacity);
grid on

xlabel('E_s/N_0')
ylabel('bit per channel use')



%Capa vs SNR - log scale
figure
semilogy(EsN0dB,ShannonCapacity);
hold on
semilogy(EsN0dB(1:5), (EsN0(1:5))/log(2),'r--')
semilogy(EsN0dB(end-10:end), log2(EsN0(end-10:end)),'g--')
grid on

xlabel('E_s/N_0')
ylabel('bit per channel use')
