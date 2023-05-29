clear all 
close all

M=4;
Nt=2;
Nr=2;
ns=10000;
EbN0dB=-10:3:15 ;
EbN0=10.^(EbN0dB/10);
array = zeros(1,length(EbN0));
sym=[1+1j 1-1j -1+1j -1-1j];

for jj=1:length(EbN0)
    err_=0;
    for k=1:ns
        % Génération des bits 
        s=randi([0,M-1],Nt,1);
        x=qammod(s,M);

        % Canal+bruit 
        H=(1/sqrt(2))*(randn(Nr,Nt)+1j*randn(Nr,Nt));
        B=sqrt(1/EbN0(jj)/2)*(randn(Nr,1)+1j*randn(Nr,1));
        y=H*x+B;

        % Récepteur sic_zf 
        [Q,R]=qr(H);
        y_tilde=R*x+Q'*B;
        u=zeros(1,Nt);
        u(Nt)=y_tilde(Nt);
        x_estim=zeros(1,Nt);
        for m=1:Nt       
            tmp=Nt-m+1;  
            som=0;
            for q=tmp+1:Nt
                som=som+R(tmp,q)*x_estim(q);
            end
            u(tmp)=y_tilde(tmp)-som;
            [~,ind]=min((abs(sym-u(tmp)).^2)./R(tmp,tmp)^2);
            x_estim(tmp)=sym(ind);
        end

        s_estime=qamdemod(x_estim,M);
        err_=err_+sum(xor(s,s_estime.'));

    end
 
  array(jj) = err_/(2*ns);
 end
  
figure 
semilogy(EbN0dB,array,'-o');
xlabel("SNR dB")
ylabel("TEB")
title("Détecteur SIC - ZF")