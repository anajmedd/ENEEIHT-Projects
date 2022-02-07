clear;
close all;
clc;



% Initialisation des paramètres
Fe = 12000;
Te = 1 / Fe;
alpha = 0.35;
span = 8;
nb_bits = 100000;
Ns = 1;
N = 50;
Ts = Ns;
Tc = 10 * Ts;
F = 1/(5*Tc);
K =5;
Eb_N0_dB=-16:0;

%--------------------------------------------------------------------------
% Implantation de la chaine de transmission
%--------------------------------------------------------------------------
% Génération de l’information binaire
bits = randi([0, 1], 1, nb_bits);

% Mapping permettant d'obtenir s ∈ {±1}
s = 2 * bits -1;

% Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs = kron(s, [1 zeros(1, Ns - 1)]);


% Génération de la réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha, 8, Ns, 'sqrt');
retard = (span * Ns) / 2;

% Filtrage de mise en forme du signal généré sur la voie I
x = filter(h, 1, [Suite_diracs zeros(1, retard)]);
x = x(retard + 1 : end);

% Filtre temps de cohérence
[b,a] = butter(1,F);
Canal_Rice = randn(1,length(x)) + 1j * randn(1,length(x));
m = filter(b,a,Canal_Rice);

alpha1 = sqrt(K * mean(abs(m) .^ 2));
yr = (alpha1 + m).*x;

TEB1 = zeros(1,17);
TEB2 = zeros(1,17);
for i = 0 : 16
    % L'ajout du bruit blanc gaussien
    Puiss_sign = mean(abs(yr) .^ 2);
    Puiss_bruit = Puiss_sign * Ns  / (2 * log2(4) * 10 .^ (i / 10));
    Bruit_gauss = (sqrt(Puiss_bruit) * randn(1, length(yr))) + 1i * (sqrt(Puiss_bruit) * randn(1, length(yr)));
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
    symboles_decides_zf = sign(real(z_zf));
    symboles_decides_ml = sign(real(z_ml));
    % Calcul du TES
    TEB1(i + 1) = length(find(symboles_decides_zf ~= s)) / (length(s));
    % Calcul du TES
    TEB2(i + 1) = length(find(symboles_decides_ml ~= s)) / (length(s));
    
end

% Comparaison entre le taux d erreur binaire (TEB) obtenu aprés égalisation
% ZF et le TEB aprés égalisation ML.
figure;
semilogy([0 : 16], TEB1, '-o');
hold on
semilogy([0 : 16], TEB2, 'k');
grid
title('TEB Sans Codage pour les égalisations ZF et ML');
legend('TEB avec égalistion ZF','TEB avec égalistion ML')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

% Calcule de la diversité
diversite_zf = polyfit(Eb_N0_dB,10*log(TEB1),1);
fprintf("La diversité pour l'égalisation ZF est : [%i %i] \n",diversite_zf);
diversite_ml = polyfit(Eb_N0_dB,10*log(TEB2),1);
fprintf("La diversité pour l'égalisation ML est : [%i %i] \n ",diversite_ml);