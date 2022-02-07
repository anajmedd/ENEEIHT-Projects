
% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
% 
close all;
clear all;

% Simulation parameters
% On décrit ci-après les paramètres généraux de la simulation

%Frame length
M=4; %2:BPSK, 4: QPSK
N  = 1000000; % Number of transmitted bits or symbols
Es_N0_dB = [0:30]; % Eb/N0 values
%Multipath channel parameters
hc=[1 0.8*exp(1i*pi/3) 0.3*exp(1i*pi/6) ];%0.1*exp(1i*pi/12)];%ISI channel
%hc=[0.04, -0.05, 0.07, -0.21, -0.5, 0.72, 0.36, 0, 0.21, 0.03, 0.07];
%a=1.2;
%hc=[1 -a];
Lc=length(hc);%Channel length
ChannelDelay=0; %delay is equal to number of non causal taps

%Preallocations
nErr_zf=zeros(1,length(Es_N0_dB));
nErr_zfinf=zeros(1,length(Es_N0_dB));
nErr_zfinfdirectimp=zeros(1,length(Es_N0_dB));
nErr_mmseinf=zeros(1,length(Es_N0_dB));
nErr_mmseinf1=zeros(1,length(Es_N0_dB));

for ii = 1:length(Es_N0_dB)

   % BPSK symbol generations
%    bits = rand(1,N)>0.5; % generating 0,1 with equal probability
%    s = 1-2*bits; % BPSK modulation following: {0 -> +1; 1 -> -1} 
   
    % QPSK symbol generations
   bits = rand(2,N)>0.5; % generating 0,1 with equal probability
   s = 1/sqrt(2)*((1-2*bits(1,:))+1j*(1-2*bits(2,:))); % QPSK modulation following the BPSK rule for each quadatrure component: {0 -> +1; 1 -> -1} 
   sigs2=var(s);
   %% Channel convolution: equivalent symbol based representation
   z = conv(hc,s);
   %Generating noise
   sig2b=10^(-Es_N0_dB(ii)/10);
   %n = sqrt(sig2b)*randn(1,N+Lc-1); % white gaussian noise, BPSK Case
   n = sqrt(sig2b/2)*randn(1,N+Lc-1)+1j*sqrt(sig2b/2)*randn(1,N+Lc-1); % white gaussian noise, QPSK case
   
   % Adding Noise
   y = z + n; % additive white gaussian noise

   s_zf=filter(1,hc,y);%if stable causal filter is existing
   s_zf_SansBruit=filter(1,hc,z);
   bhat0 = zeros(2,length(bits));
   bhat0(1,:)= real(s_zf(1:N)) < 0;
   bhat0(2,:)= imag(s_zf(1:N)) < 0;
   nErr_zf(1,ii) = size(find([bits(:)- bhat0(:)]),1);
   
  
   %% zero forcing equalization
   % We now study ZF equalization
   
   %Unconstrained ZF equalization, only if stable inverse filtering
   % 
   Nw =100;
   H= toeplitz([hc(1) zeros(1,Nw-1)]',[hc,zeros(1 ,Nw-1)]);
   Ry=conj(H)*H.';
   p=zeros(Nw+Lc-1,1);
   P=H.'*inv(Ry)*conj(H);
   [alpha,dopt]=max(diag(abs(P)));
   p(dopt)=1;
   gamma=conj(H)*p;
   w_zf_ls=(inv(Ry)*gamma).';
   sig_e_opt=sigs2-conj(w_zf_ls)*gamma;
   bias=1-sig_e_opt/sigs2;
   shat=conv(w_zf_ls,y);
   shat=shat(dopt:end);
   bhat=zeros(2,length(bits));
   bhat(1,:)=real(shat(1:N))<0;
   bhat(2,:)=imag(shat(1:N))<0;
   nErr_zfinfdirectimp(1,ii) = size(find([bits(:)- bhat(:)]),1);
   

   
   

   % MMSE avec bruit
   Nw =100;
   %  The unconstrained ZF equalizer, when existing is given by 
   H1= toeplitz([hc(1) zeros(1,Nw-1)]',[hc,zeros(1 ,Nw-1)]);
   q=sig2b/sigs2;
   Ry1=(conj(H1)*H1.'+q*eye(length(conj(H1)*H1.')));
   p=zeros(Nw+Lc-1,1);
   P=H1.'*inv(Ry1)*conj(H1);
   [alpha,dopt]=max(diag(abs(P)));
   p(dopt)=1;
   gamma=conj(H1)*p;
   w_mmse_ls=(inv(Ry1)*gamma).';
   sig_e_opt=sigs2-conj(w_mmse_ls)*gamma;
   bias=1-sig_e_opt/sigs2;
   shat1=conv(w_mmse_ls,y);
   shat1=shat1(dopt:end);
   bhat1=zeros(2,length(bits));
   bhat1(1,:)=real(shat1(1:N))<0;
   bhat1(2,:)=imag(shat1(1:N))<0;
   nErr_mmseinf(1,ii) = size(find([bits(:)- bhat1(:)]),1);
   
   
   %nErr_zfinf_br(1,ii) = size(find([bits(:)- bhat_mmse(:)]),1);
   % $w_{,\infty,zf}=\frac{1}{h(z)}$
   % 
   %%
   %
   %Otherwise, to handle the non causal case
   Nzf=200;
   [r, p, k]=residuez(1, hc);
   [w_zfinf]=ComputeRI( Nzf, r, p, k );
   s_zf=conv(w_zfinf,y);
   bhat_zf = zeros(2,length(bits));
   bhat_zf(1,:)= real(s_zf(Nzf:N+Nzf-1)) < 0;
   bhat_zf(2,:)= imag(s_zf(Nzf:N+Nzf-1)) < 0;
   nErr_zfinf(1,ii) = size(find([bits(:)- bhat_zf(:)]),1);
   % filtre MMSE
   deltac= zeros(1,2*Lc-1 ) ;
   deltac ( Lc ) = 1 ;
   Nmmse = 200 ;
   [ r , p , k ] = residuez(fliplr(conj(hc)),(conv(hc,fliplr(conj(hc)))+(sig2b/sigs2)*deltac)) ;
   [w_mmseinf] = ComputeRI ( Nmmse , r , p , k ) ;
   s_mmse=conv(w_mmseinf,y);
   bhat_mmse=zeros(2,length(bits));
   bhat_mmse(1,:)= real(s_mmse(Nmmse:N+Nmmse-1)) < 0;
   bhat_mmse(2,:)= imag(s_mmse(Nmmse:N+Nmmse-1)) < 0;
   nErr_mmseinf1(1,ii) = size(find([bits(:)- bhat_mmse(:)]),1);
    
end
ii=1;
simBer_zfinfdirectimp = nErr_zfinfdirectimp/N/log2(M); % simulated ber
simBer_zfinf = nErr_zfinf/N/log2(M); % simulated ber
simBer_mmseinf =  nErr_mmseinf/N/log2(M); % simulated ber
simBer_mmseinf1 = nErr_mmseinf1/N/log2(M); % simulated ber
simBer_zf = nErr_zf/N/log2(M);

% plot
scatterplot(y)
title("Avec bruit")
scatterplot(z)
title("sans bruit")

figure
plot(Es_N0_dB,simBer_zf)
title("TEB avec égaliseur ZF ")

% plot

figure
semilogy(Es_N0_dB,simBer_zfinfdirectimp(1,:),'bs-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_mmseinf(1,:),'rs-','Linewidth',2);
axis([0 50 10^-6 0.5])
grid on
legend('sim-zf-inf','sim-mmse-inf');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title('Egaliseurs à structure non contrainte ')

figure
title('Impulse response')   
stem(real(w_zfinf))
hold on
stem(real(w_zfinf),'r-')
ylabel('Amplitude');
xlabel('time index')




% plot

figure
semilogy(Es_N0_dB,simBer_zfinf(1,:),'bs-','Linewidth',2);
axis([0 50 10^-6 0.5])
hold on
semilogy(Es_N0_dB,simBer_mmseinf1(1,:),'rs-','Linewidth',2);
grid on
legend('sim-zf-inf/direct','sim-mmse-inf/direct');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title("Egaliseurs à structure RIF")

figure
title('Impulse response')
stem(real(w_mmseinf))
hold on
stem(real(w_mmseinf),'r-')
ylabel('Amplitude');
xlabel('time index')





