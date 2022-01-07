clc;
close all;
clear all
N= 16;
h = ones(1,N);
G = 5;
nombre_ofdm = 320; % Nombre de symboles OFDM
Nbits = nombre_ofdm*N;
bits =randi(0:1,1,Nbits); % generation de la sequence de bits
symboles = 2*bits -1;
M = reshape(symboles,N,320);

entree_ifft = zeros(N,nombre_ofdm);
for i=1:N
   entree_ifft(i,:) = M(i,:);
end
%% Filtre
Hc = [0.227 0.46 0.688 0.46 0.227];
%% IFFT
sortie_ifft = ifft(entree_ifft);
%% Ajout de zeros
signal_intervalle_zeros = zeros(N+G,nombre_ofdm);
signal_intervalle_zeros(G+1:end,:) = sortie_ifft;
% Reception 
signal_recu = reshape(signal_intervalle_zeros,1,(N+G)*nombre_ofdm);
signal_recu_filtre = filter(Hc,1,signal_recu);
signal_recu_filtre_resh = reshape(signal_recu_filtre,N+G,nombre_ofdm);
signal_entre_ifft = signal_recu_filtre_resh(G+1:end,:);
signal_sortie = fft(signal_entre_ifft);
%% Constellation
plot(signal_sortie(5,:),'+');
hold;
plot(signal_sortie(14,:),'+');
legend('5ème porteuse' , '14ème porteuse')
title("Constellations obtenues en réception avec intervalle de garde composé de zéros")

%% TEB simulé
signal_reshap = reshape(signal_sortie,1,nombre_ofdm*N);
Rl = real(signal_reshap);
NbErr = find(sign(Rl)-symboles==0);
TEB_simule = length(NbErr)/(nombre_ofdm*N)
