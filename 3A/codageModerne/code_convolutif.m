clear all
close all

% Paramètres
N = 10000;
EbN0dB = [-10:1:10];
M = 2;

% Paramètre de codage
encodeur_convolutionnel = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(7,[171 133]),'TerminationMethod', 'Truncated');

% Génération des bits 
bits_initiaux = randi([0 1],N,1);

% Codage des bits 
donnees_codees = encodeur_convolutionnel(bits_initiaux);

% Modulation
donnees_modulees = qammod(donnees_codees,M);

erreur_ml = [];
erreur_map = [];
for i=1:length(EbN0dB)
    ebn0dB_actuel = EbN0dB(i);
    % Canal Gaussien
    % Bruit
    sigma = 1;
    puissance = (sigma/10.^(ebn0dB_actuel/10));
    bruit = sqrt(puissance/2)*randn(size(donnees_modulees));
    donnees_bruitees = donnees_modulees + bruit;

    % Démodulation
    donnees_demodulees = qamdemod(donnees_bruitees,M);

    % Paramètre de décodage
    decodeur_app = comm.APPDecoder('TrellisStructure',poly2trellis(7,[171 133]),'Algorithm','True APP','CodedBitLLROutputPort',false);

    % Décodage de Vitterbi 
    decodeur_viterbi = comm.ViterbiDecoder('TrellisStructure',poly2trellis(7,[171 133]),'InputFormat','Unquantized','TerminationMethod','Truncated');

    bits_recu_ml = step(decodeur_viterbi, -donnees_bruitees);
   

    % Décodage souple
    llr = (2/(sigma.^2))*donnees_bruitees;
    bits_decode_souple = step(decodeur_app, zeros(N,1), llr);

    % Passage de la décision souple à la décision dure
    bits_recu_map = double(bits_decode_souple>0);

    % TEB
    erreur_ml = [erreur_ml sum(bits_initiaux~=bits_recu_ml)/length(bits_initiaux)];
    erreur_map = [erreur_map sum(bits_initiaux~=bits_recu_map)/length(bits_initiaux)];
end

% Affichage du TEB en fonction de EbN0dB
figure
semilogy(EbN0dB, erreur_ml, 'x-')
hold on
semilogy(EbN0dB, erreur_map, 'x-')
xlabel('E_b/N_0 [dB]')
ylabel('TEB')
legend('ML', 'MAP')
title('TEB en fonction du EbN0dB')
grid on
