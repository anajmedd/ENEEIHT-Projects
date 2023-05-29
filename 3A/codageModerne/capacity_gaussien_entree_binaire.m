ESN0db=(-20:10);
N=5000000;

for snr=1:numel(ESN0db)

bits=randn(1,N)>0;
BPSK=1-2*bits;
N0=1/10^(ESN0db(snr)/10);
bruit=sqrt(N0/2)*randn(1,N);
sigma2=N0/2;
y=BPSK+bruit;

LLR=2/sigma2*y;

%Capacity for Eb/N0=0.2dB
Capacity(snr)=1-mean(log2(1+exp(-BPSK.*LLR)));
end
figure
plot(ESN0db-10*log10(Capacity),Capacity)
hold on
plot(ESN0db+10*log10(2)-10*log10(2*Capacity),2*Capacity,'b-')
plot(ESN0db-10*log10(log2(1+10.^(ESN0db/10))),log2(1+10.^(ESN0db/10)),'r-')
grid on
xlabel('E_b/N_0')
ylabel('Capacity')
legend('BPSK Capacity','QPSK capacity','Gaussian Inputs Capacity')

figure
plot(ESN0db,Capacity)
hold on
plot(ESN0db+10*log10(2),2*Capacity,'b-')
plot(ESN0db,log2(1+10.^(ESN0db/10)),'r-')
grid on
xlabel('E_s/N_0')
ylabel('Capacity')
legend('BPSK Capacity','QPSK capacity','Gaussian Inputs Capacity')
