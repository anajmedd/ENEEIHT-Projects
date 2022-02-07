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
P = [1 1 0 1];
%
%--------------------------------------------------------------------------
% Implantation de la chaine sans bruit
%--------------------------------------------------------------------------
% Génération de l’information binaire
bits = randi([0, 1], 1, nb_bits);

% Generation du treillis 
trellis = poly2trellis([7], [171 133]);
% Generation du code convolutif
ak = 2*convenc(bits(1:2:end),trellis,P)-1;
bk = 2*convenc(bits(2:2:end),trellis,P)-1;
dk = ak + 1j * bk;


% Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs1 = kron(ak, [1 zeros(1, Ns - 1)]);
Suite_diracs2 = kron(bk, [1 zeros(1, Ns - 1)]);

% Génération de la réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha, 8, Ns, 'sqrt');
retard = (span * Ns) / 2;

% Filtrage de mise en forme du signal généré sur la voie I
I = filter(h, 1, [Suite_diracs1 zeros(1, retard)]);
I = I(retard + 1 : end);

% Filtrage de mise en forme du signal généré sur la voie Q
Q = filter(h, 1, [Suite_diracs2 zeros(1, retard)]);
Q = Q(retard + 1 : end);

% Le signal transmis sur fréquence porteuse
x =  I + 1i * Q;

ES = zeros(1,9);
TEB = zeros(1,9);
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
    
    % Detecteur à seuil
    for j = 1 : length(z_echant)
        if (real(z_echant(j)) <= 0 && imag(z_echant(j)) <= 0)
            symboles_decides(j) = -1 - 1i;
            
        elseif (real(z_echant(j)) >= 0 && imag(z_echant(j)) >= 0)
            symboles_decides(j) = 1 + 1i;
            
        elseif (real(z_echant(j)) <= 0 && imag(z_echant(j)) >= 0)
            symboles_decides(j) = -1 + 1i;
            
        elseif (real(z_echant(j)) >= 0 && imag(z_echant(j)) <= 0)
            symboles_decides(j) = 1 - 1i;
        end
    end

    ak_dec = (real(symboles_decides)+1)/2;
    bk_dec = (imag(symboles_decides)+1)/2;
    decoded1 = vitdec(ak_dec,trellis,5000,'trunc','Hard',P);
    decoded2 = vitdec(bk_dec,trellis,5000,'trunc','Hard',P);
    bits_decides = bits;
    bits_decides(1:2:end) = decoded1;
    bits_decides(2:2:end) = decoded2;
    
    % Calcul du TES
    TES(i + 1) = length(find(bits_decides ~= bits)) / (length(bits));

    
     %Calcul du TEB
    TEB(i + 1) = TES(i + 1) / 2;
end

%%
% Comparaison entre le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
% et le TEB théorique
figure;
semilogy([-4 : 4], TEB, 'b');
hold on
semilogy([-4 : 4], (4 * (1 - (1 / sqrt(4))) * qfunc(sqrt(3 * log2(4)* 10 .^ ([-4 : 4] / 10) / (3)))) / log2(4));

grid
title('Comparaison entre le TEB théorique et le TEB simulé poinçonné');
legend('TEB simulé R=2/3 poinçonné','TEB théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');