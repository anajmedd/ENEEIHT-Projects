clc;
close all;
clear all
N= 16;
h = ones(1,N);
nombre_ofdm = 320; % Nombre de symboles OFDM
Nbits = nombre_ofdm*N;
bits =randi(0:1,1,Nbits); % generation de la sequence de bits
symboles = 2*bits -1;
M = reshape(symboles,N,320);

entree_ifft = zeros(N,nombre_ofdm);
for i=1:N
   entree_ifft(i,:) = M(i,:);
end
%% IFFT
sortie_ifft = ifft(entree_ifft);
% Signal OFDM
signal_ofdm = reshape(sortie_ifft,1,N*nombre_ofdm);
%% DSP
[DSP,f] = pwelch(signal_ofdm,1024,512,1024,N);
% Réponse en fréquence du canal
Hc = [0.227 0.46 0.688 0.46 0.227];
figure(1)
freqz(Hc, 1);
% Passage par le canal 
signal_sortie = filter(Hc,1,signal_ofdm);
[Dsp_canal, f] = pwelch(signal_sortie, 1024, 512, 1024, N);
figure(2)
plot(f,10*log10(Dsp_canal/max(abs(Dsp_canal))))
grid on 
xlabel('f')
ylabel('dB')
title('DSP recu après passage par le canal')

%% Constellations en récéption
signal_reshaped_sortie = reshape(signal_sortie, [N nombre_ofdm]);
signal_reshaped_fft = fft(signal_reshaped_sortie);
figure(3)
plot(signal_reshaped_fft(5,:),'+');
hold;
plot(signal_reshaped_fft(14,:),'+');
legend('5ème porteuse' , '14ème porteuse')
title('Constellations obtenues en réception sans intervalle de garde')
%% TEB simulé 
Rl = real(signal_reshaped_fft);
NbErr = find(sign(Rl)-entree_ifft==0);
TEB_simule = length(NbErr)/(nombre_ofdm*N)
