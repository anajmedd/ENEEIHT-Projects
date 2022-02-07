% Script for computing the BER for BPSK modulation in ISI Channels
%
close all;
clear all;
clc;

%% Simulation parameters
% On décrit ci-après les paramètres généraux de la simulation

%modulation parameters
M = 4; %Modulation order
Nframe = 100;
Nfft=1024;
Ncp=8;
Ns=Nframe*(Nfft+Ncp);
N= log2(M)*Nframe*Nfft;
hMod = comm.QPSKModulator('BitInput',true);
hDemodHD = comm.QPSKDemodulator('BitOutput',true,...
    'DecisionMethod', 'Hard decision');


%Channel Parameters
Eb_N0_dB = [0:70]; % Eb/N0 values
%Multipath channel parameters
%hc=[1 -0.9];
hc1=[0.227, 0.46, 0.688, 0.460, 0.227];
hc2=[0.227, 0.46, 0.688, 0.460, 0.227];
Lc1=length(hc1);%Channel length
Lc2=length(hc2);%Channel length
H1=fft(hc1,Nfft);
H2=fft(hc2,Nfft);
%Preallocations
nErr_zffde=zeros(1,length(Eb_N0_dB));
nErr_mmsefde=zeros(1,length(Eb_N0_dB));
biasvect=zeros(1,length(Eb_N0_dB));
for ii = 1:length(Eb_N0_dB)

   disp(ii);
   %Message generation

   %User 1
   bits1= randi([0 1],N/2,1);
   s1 = step(hMod, bits1);
   smat1 = reshape(s1,Nfft/2,Nframe);
   S1 = fft(smat1,Nfft/2,1);
   s11 = ifft([S1;zeros(Nfft/2,Nframe)],Nfft,1);

   sigs2=var(s1);

   %User 2
   bits2= randi([0 1],N/2,1);
   s2 = step(hMod, bits2);
   smat2 = reshape(s2,Nfft/2,Nframe);
   S2 = fft(smat2,Nfft/2,1);
   s22 = ifft([zeros(Nfft/2,Nframe);S2],Nfft,1);

   %Add CP

   %User 1
   smatcp1=[s11(end-Ncp+1:end,:);s11];
   scp1=reshape(smatcp1,1,(Nfft+Ncp)*Nframe);


   %User 2
   smatcp2=[s22(end-Ncp+1:end,:);s22];
   scp2=reshape(smatcp2,1,(Nfft+Ncp)*Nframe);

   % Channel convolution: equivalent symbol based representation

   %User 1
   z1 = filter(hc1,1,scp1);

   %User 2
   z2 = filter(hc2,1,scp2);


   %Generating noise
   sig2b=10^(-Eb_N0_dB(ii)/10);

   %n = sqrt(sig2b)*randn(1,N+Lc-1); % white gaussian noise,
   n = sqrt(sig2b/2)*randn(1,Ns)+1j*sqrt(sig2b/2)*randn(1,Ns); % white gaussian noise,

    % Noise addition
   ycp = z1 + z2 + n; % additive white gaussian noise

   %remove CP
   ymatcp=reshape(ycp,Nfft+Ncp,Nframe);

   y = ymatcp(Ncp+1:end,:);

   %user 1

   H = H1;

   bits = bits1; % estimation user 1 

   %% zero forcing equalization
   % We now study ZF equalization
   Wzf=1./H;
   Y=fft(y,Nfft,1);
   Yf=diag(Wzf)*Y;%static channel
   xhat_zf=ifft(Yf(1:Nfft/2,:),Nfft/2,1); % Nfft/2+1 : end
   bhat_zfeq = step(hDemodHD,xhat_zf(:));
   %%%%%%

   %% MMSE Equalization
   % We now study MMSE equalization
   Wmmse=conj(H)./(abs(H).^2+sig2b/sigs2);
   Y=fft(y,[],1);
   Yf=diag(Wmmse)*Y;
   xhat_mmse=ifft(Yf(1:Nfft/2,:),[],1);
   bhat_mmseeq = step(hDemodHD,xhat_mmse(:));
   %%%%%%
    nErr_zffde(1,ii) = size(find([bits(:)- bhat_zfeq(:)]),1);
    nErr_mmsefde(1,ii) = size(find([bits(:)- bhat_mmseeq(:)]),1);
    biasvect(ii)=1/Nfft*sum(Wmmse.*H);
end

simBer_zf = nErr_zffde/N/2; % simulated ber
simBer_mmse = nErr_mmsefde/N/2; % simulated ber
% plot

figure
semilogy(Eb_N0_dB,simBer_zf(1,:),'bs-','Linewidth',2);
hold on
semilogy(Eb_N0_dB,simBer_mmse(1,:),'rd-','Linewidth',2);
axis([0 70 10^-6 0.5])
grid on
legend('sim-zf-fde','sim-mmse-fde');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for QPSK in ISI with ZF and MMSE equalizers')

bias= 1/Nfft*sum(Wmmse.*H);
% figure
% %subplot(211)
% stem(real(w_zfinf),'r-')
