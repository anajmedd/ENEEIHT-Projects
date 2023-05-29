clear all
close all
% Paramètres 
N = 1000; 
EbN0_dB = 0:2:20; 
EbN0 = 10.^(EbN0_dB/10); 
BER_ML = []; 
BER_MAP = []; 

for i = 1:length(EbN0_dB)
    % génération des bits
    data_symbols = (rand(1,N) > 0.5) * 2 - 1; 
    
    %répétition des symboles 
    rep_data_symbols=repelem(data_symbols,3);
    % Ajout du bruit au signal
    noise_variance = 1 / (2 * EbN0(i)); 
    noise = sqrt(noise_variance) * randn(1,length(rep_data_symbols)); 
    received_signal = rep_data_symbols + noise; 
    
    % Détecteur Maximum Likelihood 
    % La valeur la plus proche du signal reçu 
    detected_symbols_ML = sign(received_signal(1:3:end)); 
    
    % Détecteur Maximum A Posteriori 
    % La valeur avec la probabilité la plus élevée
    detected_symbols_MAP = (received_signal(1:3:end) > 0) * 2 - 1;
    
    % TEB
    BER_ML(i) = sum(detected_symbols_ML ~= data_symbols) / N; 
    BER_MAP(i) = sum(detected_symbols_MAP ~= data_symbols) / N;
end

% courbes TEB 
figure
semilogy(EbN0_dB, BER_ML, '-o') 
xlabel('Eb/N0 (dB)');
ylabel('TEB');
title('TEB du détecteur ML');
grid on;

figure
semilogy(EbN0_dB, BER_MAP, '-*') 
xlabel('Eb/N0 (dB)');
ylabel('TEB');
title('TEB du détecteur MAP');
grid on;