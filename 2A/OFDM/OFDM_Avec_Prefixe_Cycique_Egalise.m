clc;
close all;
clear all
N= 16;
h = ones(1,N);
G = 5;
nombre_ofdm = 500; % Nombre de symboles OFDM
Nbits = nombre_ofdm*N;
bits =randi(0:1,1,Nbits); % generation de la sequence de bits
symboles = 2*bits -1;
M = reshape(symboles,N,nombre_ofdm);

entree_ifft = zeros(N,nombre_ofdm);
for i=1:N
   entree_ifft(i,:) = M(i,:);
end
%% Filtre
Hc = [0.227 0.46 0.688 0.46 0.227];
%% IFFT
sortie_ifft = ifft(entree_ifft);
%% Ajout du PC
signal_intervalle_zeros = zeros(N+G,nombre_ofdm);
prefix_cyclique = sortie_ifft(end-G+1:end,:);
smatcp = [prefix_cyclique;sortie_ifft];
% Reception 
signal_recu = reshape(smatcp,1,(N+G)*nombre_ofdm);
signal_recu_filtre = filter(Hc,1,signal_recu);
signal_recu_filtre_resh = reshape(signal_recu_filtre,N+G,nombre_ofdm);
signal_entre_ifft = signal_recu_filtre_resh(G+1:end,:);
signal_sortie = fft(signal_entre_ifft);

Hc_fft = fft(Hc,N);
smat = zeros(N,nombre_ofdm);
%% Egalisation ZF
for ii=1:nombre_ofdm
   smat(:,ii) = signal_sortie(:,ii)./transpose(Hc_fft);
end

%% Constellation
scatterplot(smat(5,:),10);
title("Constellations obtenues en réception avec l'égalisation ZF Porteuse 5")
scatterplot(smat(14,:),10);
title("Constellations obtenues en réception avec l'égalisation ZF Porteuse 14")

%% TEB simulé
Rl = real(signal_sortie);
Nberr = find(sign(Rl)-entree_ifft==0);
TEB_simule = length(Nberr)/(nombre_ofdm*N)