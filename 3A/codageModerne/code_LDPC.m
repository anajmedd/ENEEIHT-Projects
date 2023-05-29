close all;
clear all;

%%%%%%%%%
%LDPC Parameters
%%%%%%%%%%%%%%%%%%%%%%
R=1/2;
H = dvbs2ldpc(R);
[M,N]=size(H);
K=N-M;
spy(H);   % Visualize the location of nonzero elements in H.
LDPCencode = comm.LDPCEncoder(H); 
itermax=10;
iterstep=1;
LLRmax=30;
CtoV=double(H);
nz=nnz(H);
%modem
modulateur=comm.PSKModulator('ModulationOrder',8,'SymbolMapping', 'Gray','BitInput',true); % note that default
ConstellationSymbols=constellation(modulateur);
Es=mean(abs(ConstellationSymbols).^2);
%awgn channel
SNRrange=(0:4);
FER=zeros(1,length(SNRrange));
perf=zeros(1,length(SNRrange));
ii=1;
VTEB=[];


for SNRdb=SNRrange
esno=10^(SNRdb/10);
%Es=1; %for BPSK use only
sig2=Es/R/esno/log2(8);
teb=0;
demodulateur = comm.PSKDemodulator('ModulationOrder',8,'SymbolMapping', 'Gray','BitOutput',true,'DecisionMethod','Log-likelihood ratio','Variance',sig2);
mc=0;
MC=10;

while (FER(ii)<100)&&(mc<(MC+1))
SNRdb, mc
msg = randi([0,1],K,1);  
%msg = zeros(1,N);
codeword = LDPCencode(msg)';
modulatedsig=modulateur(codeword.');
b=sqrt(sig2/2)*(randn(1,length(modulatedsig))+1i*randn(1,length(modulatedsig)));
y=modulatedsig+b.';

%initialisation

%CtoVinit=zeros(nz,1);
Lch=demodulateur(y);
iter=0;
paritychecks=1;
while (sum(paritychecks)~=0) && (iter<itermax)
[APPllr,VtoC,CtoV,iter]=myBPdecoder(Lch,CtoV,H,iterstep,iter);
cw=(1-sign(APPllr))/2;
errors=sum(cw(1:end/2)~=msg.');

paritychecks = mod(H* cw', 2);
%index=find(VtoC~=0);
figure(1)
hist(APPllr,50)
 drawnow;
 figure(2)
hist(Lch,50)
 drawnow;

end
iter
teb=teb+errors;
if errors
   FER(ii)=FER(ii)+1;
end
mc=mc+1;

end

hold on 

FER(ii)=FER(ii)/mc;
perf(ii)=teb/mc/(N/2);
ii=ii+1;


end

figure
semilogy(SNRrange,perf)


FER
