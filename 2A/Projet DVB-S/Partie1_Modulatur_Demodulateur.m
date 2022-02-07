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

%%
%--------------------------------------------------------------------------
% Implantation de la chaine sans bruit
%--------------------------------------------------------------------------
% Génération de l’information binaire
bits = randi([0, 1], 1, nb_bits);

% Mapping permettant d'obtenir dk ∈ {±1 ± j}
ak = 2 * bits(1 : 2 : end) - 1;
bk = 2 * bits(2 : 2 : end) - 1;
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
    Puiss_bruit = Puiss_sign * Ns  / (2 * log2(4) * 10 .^ (i / 10));
    Bruit_gauss = (sqrt(Puiss_bruit) * randn(1, length(x))) + 1i * (sqrt(Puiss_bruit) * randn(1, length(x)));
    y = x + Bruit_gauss;
    
    % Filtrage de réception
    h_r = h;
    z = filter(h_r, 1, [y zeros(1,retard)]);
    z = z(retard + 1 : end);
    
    % Echantillonnage du signal
    z_echant = z(1 : Ns : end);
    
    % Les constellations en sortie du mapping et de l’échantillonneur
    figure;
    plot(real(z_echant), imag(z_echant), 'r*');
    hold on;
    plot(ak, bk, 'b*');
    legend('Les constellations en sortie du mapping','Les constellations en sortie de l’échantillonneur')
    xlabel('I');
    ylabel('Q');
    
    % Detecteur à seuil
    symboles_decides = zeros(1,length(z_echant));
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
    
    % Calcul du TES
    TES(i + 1) = length(find(symboles_decides ~= dk)) / (length(dk));
    
    % Calcul du TEB
    TEB(i + 1) = TES(i + 1) / 2;
end

%%
% Comparaison entre le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
% et le TEB théorique
figure;
semilogy([0 : 8], TEB, 'b');
hold on
semilogy([0 : 8], (4 * (1 - (1 / sqrt(4))) * qfunc(sqrt(3 * log2(4)* 10 .^ ([0 : 8] / 10) / (3)))) / log2(4));
grid
title('Figure 2 : Comparaison entre le TEB théorique et estimé');
legend('TEB estimé','TEB théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');
