clear all 
close all 

Nr=2;
Nt=2; 
M=4;
ns=10000;


EbN0dB=-10:3:15 ;
EbN0=10.^(EbN0dB/10);

T = zeros(1,length(EbN0));
for jj=1:length(EbN0)
    err_=0;
    for ii=1:ns
        % Génération des bits 
        s=randi([0,M-1],Nt,1);
        x=qammod(s,M);

        % Canal+bruit 
        H=(1/sqrt(2))*(randn(Nr,Nt)+1j*randn(Nr,Nt));
        B=sqrt(1/EbN0(jj)/2)*(randn(Nr,1)+1j*randn(Nr,1));
        y=H*x+B;

        % Récépteur ML :
        mots = de2bi((0:M^Nt-1)','left-msb');
        symboles=2*[mots(:,1)+1j*mots(:,2) mots(:,3)+1j*mots(:,4)]-(ones(16,2)+1j*ones(16,2));
        ts=symboles.' ;
        P=H*ts;
       
        module=sum(abs(P-y).^2);
        [~,ind]=min(module);
        x_chap=ts(:,ind);
        s_chap=qamdemod(x_chap,M);
        err_=err_+sum(xor(s_chap,s));
        
    end
 T(jj) = err_/(2*ns);

end


figure
semilogy(EbN0,T,'-o')
xlabel("SNR")
ylabel("TEB")
title("Détecteur ML-MAP")



