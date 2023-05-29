clear all 
close all 

%modulation parameters
M = 4; %Modulation order 
k=log2(M);
Nr=4;
Nt=2;
ns=3000;  % nb of symbol per user 
N=ns*Nt;


EbN0dB=-10:3:15 ;
EbN0=10.^(EbN0dB/10);
T=zeros(1,length(EbN0));

%% Egalisation ZF
for jj=1:length(EbN0)
err_=0;
for ii=1:ns
    %génération des symboles
    s=randi([0,M-1],Nt,1);
    x=qammod(s,M);
    %canal
    H=(1/sqrt(2))*(randn(Nr,Nt)+1j*randn(Nr,Nt));
    sig=var(x);
    B=sqrt(1/EbN0(jj)/2)*(randn(Nr,1)+1j*randn(Nr,1));
    y=H*x+B;
    %égalization zf 
    w=inv(transpose(H)*H)*transpose(H);
    x_chap=w*y;

    s_chap=qamdemod(x_chap,M);
    err=sum(xor(s,s_chap));
    err_=err_+err ;
end
T(jj) = err_/N;
end





%% Egalisation MMSE
Vecteur_Err_mmse=[];
G=zeros(1,length(EbN0));
for jj=1:length(EbN0)
err_=0;
N0 = 1/(10^(EbN0dB(k)/10));
for ii=1:ns
    %génération des symboles
    s=randi([0,M-1],Nt,1);
    x=qammod(s,M);
    %canal
    H=(1/sqrt(2))*(randn(Nr,Nt)+1j*randn(Nr,Nt));
    sig=var(x);
    B=sqrt(1/EbN0(jj))*(randn(Nr,1)+1j*randn(Nr,1));
    y=H*x+B;  
    %égalization MMSE
    EsN0=EbN0(jj)*log2(M);
    w=H*inv(H'*H+(N0/log2(M))*eye(Nt));
    x_chap=w'*y;
    s_chap=qamdemod(x_chap,M);
    err=sum(xor(s,s_chap));
    err_=err_+err ;


end
G(jj) = err_/N; 
end

figure
% comparaison des TEBs 
semilogy(EbN0,T,'-o');
hold on 
semilogy(EbN0,G,'-*');

legend("ZF","MMSE")
xlabel("SNR en dB")
ylabel("TEB")
title("Détecteur zf / MMSE")
