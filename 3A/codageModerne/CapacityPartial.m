clear all;

%%%%
EbN0db=0.187;
N=1000000;
bits=randn(1,N)>0;
BPSK=1-2*bits;
R=0.5;
N0=1/R/10^(EbN0db/10);

bruit=sqrt(N0/2)*randn(1,N);
sigma2=N0/2;
y=BPSK+bruit;

LLR=2/sigma2*y;

%Capacity for Eb/N0=0.2dB
Capacity=1-mean(log2(1+exp(-BPSK.*LLR)))

%convergence of mean estimator
CapacityPartial=1-1./(1:N).*cumsum(log2(1+exp(-BPSK.*LLR)));
semilogx((1:N),CapacityPartial,'.')
hold on
semilogx((1:N),CapacityPartial(end)*ones(1,N),'-')

grid on
xlabel('trials')
ylabel('Capacity')