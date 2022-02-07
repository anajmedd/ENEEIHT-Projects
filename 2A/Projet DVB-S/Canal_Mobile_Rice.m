clear;
close all;
clc;



% Initialisation des paramètres
Fe = 12000;
Te = 1 / Fe;
alpha = 0.35;
span = 8;
fp = 2000;
fc = 1500;
Rs = 3000;
nb_bits = 100000;
Ns = 1;
N = 50;
Ts = Ns;
M=4;
Tc = 10 * Ts;
F = 1/(5*Tc);
K =5;
Eb_N0_dB=-16:0;

%--------------------------------------------------------------------------
% Implantation de la chaine de transmission
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

% Filtre temps de cohérence
[b,a] = butter(1,F);
Canal_Rice = randn(1,length(x)) + 1j * randn(1,length(x));
m = filter(b,a,Canal_Rice);

alpha1 = sqrt(K * mean(abs(m) .^ 2));
yr = (alpha1 + m).*x;

TEB1 = zeros(1,17);
TEB2 = zeros(1,17);
for ii = 0 : 16
    % L'ajout du bruit blanc gaussien
    Puiss_sign = mean(abs(x) .^ 2);
    Puiss_bruit = Puiss_sign * Ns  / (2 * log2(4) * 10 .^ ((ii-8) / 10));
    Bruit_gauss = (sqrt(Puiss_bruit) * randn(1, length(x))) + 1i * (sqrt(Puiss_bruit) * randn(1, length(x)));
    y = yr + Bruit_gauss;
    
    % Filtrage de réception
    h_r = h;
    z = filter(h_r, 1, [y zeros(1,retard)]);
    z = z(retard + 1 : end);
    
    % Echantillonnage du signals
    z_echant = z(1 : Ns : end);

    % Egalisation ZF
    w = alpha1 + m;
    w_zf = w(1:Ns:end);
    z_zf = z_echant./w_zf;
    z_ml = z_echant.*conj(w_zf);

    % Demodulation aprés égalisation ZF
    % Detecteur à seuil
    symboles_decides_zf = zeros(1,length(z_zf));
    for j = 1 : length(z_zf)
        if (real(z_zf(j)) <= 0 && imag(z_zf(j)) <= 0)
            symboles_decides_zf(j) = -1 - 1i;
            
        elseif (real(z_zf(j)) >= 0 && imag(z_zf(j)) >= 0)
            symboles_decides_zf(j) = 1 + 1i;
            
        elseif (real(z_zf(j)) <= 0 && imag(z_zf(j)) >= 0)
            symboles_decides_zf(j) = -1 + 1i;
            
        elseif (real(z_zf(j)) >= 0 && imag(z_zf(j)) <= 0)
            symboles_decides_zf(j) = 1 - 1i;
        end
    end

    % Demodulation aprés égalisation ML
    % Detecteur à seuil
    symboles_decides_ml = zeros(1,length(z_ml));
    for ll = 1 : length(z_ml)
        if (real(z_ml(ll)) <= 0 && imag(z_ml(ll)) <= 0)
            symboles_decides_ml(ll) = -1 - 1i;
            
        elseif (real(z_ml(ll)) >= 0 && imag(z_ml(ll)) >= 0)
            symboles_decides_ml(ll) = 1 + 1i;
            
        elseif (real(z_ml(ll)) <= 0 && imag(z_ml(ll)) >= 0)
            symboles_decides_ml(ll) = -1 + 1i;
            
        elseif (real(z_ml(ll)) >= 0 && imag(z_ml(ll)) <= 0)
            symboles_decides_ml(ll) = 1 - 1i;
        end
    end
   
    
    % Calcul du TEB
    TEB1(ii + 1) = length(find(symboles_decides_zf ~= dk)) / (length(dk));
    % Calcul du TEB
    TEB2(ii + 1) = length(find(symboles_decides_ml ~= dk)) / (length(dk));
    
end

% Comparaison entre le taux d erreur binaire (TEB) obtenu aprés égalisation
% ZF et le TEB aprés égalisation ML.


figure;
semilogy([0: 16], TEB1, '-o');
hold on
semilogy([0 : 16], TEB2, 'k');
grid
title('TEB Sans Codage pour les égalisations ZF et ML');
legend('TEB avec égalistion ZF','TEB avec égalistion ML')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

% Calcule de la diversité
diversite_ZF = polyfit(Eb_N0_dB,10*log(TEB1),1);
fprintf("(2.3.2) La diversité obtenu est [%i %i] \n",diversite_ZF);
diversite_ml = polyfit(Eb_N0_dB,10*log(TEB2),1);
fprintf("(2.3.2) La diversité obtenu est [%i %i] \n",diversite_ml);
