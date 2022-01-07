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
% Implantation de la chaine de transmission OFDM sans canal
% une seule porteuse parmi 16 est utilisée.

% Emission 1
N_porteuse = 10;
signal_ofdm1 = [];
for k=1:length(symboles)
      bloc_symboles = zeros(1,N);
      bloc_symboles(N_porteuse) = symboles(k);
      sortie1_ifft = ifft(bloc_symboles);
      signal_ofdm1 = [signal_ofdm1 sortie1_ifft];
end
figure(1);
plot(signal_ofdm1);
figure(2);
pwelch(signal_ofdm1);


%Deux porteuses parmi 16 est utilisées

% Emission 2
positions = [5,12];
entree_ifft = zeros(N,320);
for i=1:2
    entree_ifft(positions(i),:) = M(i,:);
end

% Modulation OFDM du signal
sortie2_ifft = ifft(entree_ifft);
signal_ofdm2 = reshape(sortie2_ifft,1,N*320);
figure(3)
plot(signal_ofdm2)
figure(4)
pwelch(signal_ofdm2)

%Les 8 porteuse central sont utilisées

%% Emission 3
entree_ifft = zeros(N,320);
symboles_util = [];
for ii=1:8
    entree_ifft(ii+4,:) = M(ii+4,:);
    %symboles_util = [symboles_util M(ii+4,:)];
end
sortie3_ifft = ifft(entree_ifft);
signal_ofdm3 = reshape(sortie3_ifft,1,N*320);
figure(5)
plot(signal_ofdm3)
figure(6)
pwelch(signal_ofdm3);

% Réception 1

received_data = zeros(1,length(symboles));
bloc_recu = reshape(signal_ofdm1,N,length(symboles));
for jj=1:length(symboles)
  %sortie_fft = zeros(1,N);
  sortie_fft = fft(bloc_recu(:,jj));
  received_data(jj) = sortie_fft(N_porteuse);
end 
nb_erreurs1 = length(find(received_data ~=symboles));
TEB1 = nb_erreurs1/Nbits;

% Reception 2

bloc_recu2 = real(fft(sortie2_ifft));
received_data2 = zeros(2,nombre_ofdm);
for k=1:2
    received_data2(k,:) = bloc_recu2(positions(k),:);
end
nb_erreurs2 = length(find(sign(received_data2) ~= M(1:2,:)));
TEB2 = nb_erreurs2/(2*nombre_ofdm);

% Reception 3

bloc_recu3 = fft(sortie3_ifft);
received_data3 = zeros(8,nombre_ofdm);
for kk=1:8
   received_data3(kk,:) = bloc_recu3(kk+4,:);
end
%received_data3 = reshape(received_data3,1,8*nombre_ofdm);
nb_erreurs3 = length(find(sign(real(received_data3)) ~= M(5:12,:)));
TEB3 = nb_erreurs3/(8*nombre_ofdm);




% Emission
symboles_ofdm = [];
for k=1:N:length(symboles)-N+1
	ofdm_bloc = ifft(symboles(k:k+N-1));
	symboles_ofdm = [symboles_ofdm ofdm_bloc];
end

% Calcul et tracage de la DSP
[pxx,f] = pwelch(symboles_ofdm, 1024, 512, 1024, N);
figure(7)
plot(f, 10*log10(pxx/max(abs(pxx))))
grid on 
xlabel('f')
ylabel('dB')
title('Densité spectrale du signal OFDM')

% Réception
symbols_recus = [];
for k=1:N:length(symboles)-N+1
	bloc_symbols_recus = fft(symboles_ofdm(k:k+N-1));
	symbols_recus = [symbols_recus bloc_symbols_recus];
end

% Calcul TEB
% Le TEB doit etre nul  (TEB = 0)
TEB = length(find(sign(real(symbols_recus))~= symboles))/length(symboles);



