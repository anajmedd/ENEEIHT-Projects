clear;
close all;
clc;




% Initialisation des paramètres
Fe = 10000;
Te = 1 / Fe;
alpha = 0.35;
span = 8;
fp = 2000;
fc = 1500;
Rs = 3000;
nb_bits = 10000;
Ns = 8;
N = 50;
M=4;

%%
%--------------------------------------------------------------------------
% Implantation de la chaine de transmission
%--------------------------------------------------------------------------
% Génération de l’information binaire
bits = randi([0, 1], 1, nb_bits);

% Generation du treillis 
treillis = poly2trellis([7], [171 133]);
% Generation du code convolutif
bits_codes = convenc(bits,treillis).';
% Modulation QPSK
s = qammod(bits_codes,M,'InputType','bit').';
% Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs = kron(s, [1 zeros(1, Ns - 1)]);


% Génération de la réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha, 8, Ns, 'sqrt');
retard = (span * Ns) / 2;

% Filtrage de mise en forme du signal généré sur la voie I
x = filter(h, 1, [Suite_diracs zeros(1, retard)]);
x = x(retard + 1 : end);

ES = zeros(1,9);
TEB = zeros(1,9);
TEB_soft = zeros(1,9);

for i = 0 : 8
    % L'ajout du bruit blanc gaussien
    Puiss_sign = mean(abs(x) .^ 2);
    Puiss_bruit = Puiss_sign * Ns  / (2 * log2(4) * 10 .^ ((i-4) / 10));
    Bruit_gauss = (sqrt(Puiss_bruit) * randn(1, length(x))) + 1i * (sqrt(Puiss_bruit) * randn(1, length(x)));
    y = x + Bruit_gauss;
    
    % Filtrage de réception
    h_r = h;
    z = filter(h_r, 1, [y zeros(1,retard)]);
    z = z(retard + 1 : end);
  
    % Echantillonnage du signal
    z_echant = z(1 : Ns : end);

    % Demodulation
    bits_decide_soft = qamdemod(z_echant,M,'OutputType','llr');
    vecteur_bits_decide = reshape(bits_decide_soft,1,2*size(bits_decide_soft,2));
    % Decodage 
    bits_dec = vitdec(vecteur_bits_decide,treillis,35,'trunc','unquant');

    %Calcul du TEB
    TEB_soft(i+1)=length(find(bits_dec ~= bits)) / (length(bits));
end

%%
% Comparaison entre le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
% et le TEB théorique
figure;
semilogy([-4 : 4], TEB_soft, 'b');
hold on
semilogy([-4 : 4], (4 * (1 - (1 / sqrt(4))) * qfunc(sqrt(3 * log2(4)* 10 .^ ([-4 : 4] / 10) / (3)))) / log2(4));

grid
title('Figure 1 : Comparaison entre le TEB théorique sans codage et estimé codage Soft');
legend('TEB estimé avec codage Soft','TEB théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

