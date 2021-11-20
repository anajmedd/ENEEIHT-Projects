clc;
close all;
clear all

Nbits = 1000;
Rb = 2000;
Fe = 10000;
Te = 1/Fe;
fc = 400;
fp = 2000;
Nb = Fe/Rb;
M = 4;
Ns = 8;
N = 40;
h = ones(1,Ns);
Eb_N0_db = [0:8];
alpha = 0.35;
span = 4;
dirac = [1 zeros(1,Ns -1)];
h_c = rcosdesign(alpha, span, Ns);


%% 3.2.1 - Implantation de la chaine sur fréquence porteuse
% Generatioon du mapping binaire
bits =randi(0:1,1,Nbits);
Symboles_a = 2*bits(1:2:end) -1;
Symboles_b = 2*bits(2:2:end) -1;
Symboles_d = complex(Symboles_a, Symboles_b);

suite_diracs = kron(Symboles_d,dirac);

% Mise en forme du signal
xe = filter(h_c,1,[suite_diracs zeros(1,span*Ns/2)]);
xe = xe(span*Ns/2 +1 : end);

figure(1);
xe_real = real(xe);
plot(xe_real)
axis([0 2000 -1 1])
title("Signal généré sur la voie en phase")
ylabel("Signal généré")
figure(2);
xe_imag = imag(xe);
plot(xe_imag)
axis([0 2000 -1 1])
title("Signal généré sur la voie en quadrature")
ylabel("Signal généré")

figure(3);
x = real(xe.*exp(2*pi*j*fp*[1:length(xe)]*Te));
plot(x)
axis([0 1000 -1 1])
title("Signal modulé sur porteuse")
ylabel("Signal généré")

% Calcul de la DSP
DSP_x = (1 /length (x)) * abs (fft (x, 2 ^ nextpow2(length(x)))).^ 2;
figure(4);
plot(linspace(-Fe/2, Fe/2,length(DSP_x)),fftshift(DSP_x))
title("Densité spectrale du signal modulé sur porteuse")
xlabel("Frequence en HZ")
ylabel("DSP")


% Implantation de la chaine compléte
Signal_I = x.* cos(2 * pi * fp * [1:length(xe)]*Te);
Signal_Q = x.* sin(2 * pi * fp * [1:length(xe)]*Te);

% Filtrage passe bas
filtre_pass_bas = ones(1,3);
signal_I_filtre = filter(filtre_pass_bas, 1,Signal_I);
signal_Q_filtre = filter(filtre_pass_bas, 1,Signal_Q);
signal_filtre = signal_I_filtre - 1i*signal_Q_filtre;

% Passage par le filtre de reception

h_r = h_c;
x_r = filter(h_r, 1, [signal_filtre zeros(1, span*Ns/2)]);
x_r = x_r(span*Ns/2 +1:end);

% Échantillonnage 
x_ech = x_r(1:Ns:end);

% Demapping 
bits_rec = zeros(1,Nbits);
symboles_a_r = (sign(real(x_ech))+1)/2;
symboles_b_r = (sign(imag(x_ech))+1)/2; 
bits_rec(1:2:end) = symboles_a_r;
bits_rec(2:2:end) = symboles_b_r;

nb_erreurs = length(find(bits ~= bits_rec));
TEB = nb_erreurs/length(bits);
fprintf("4. Le TEB obtenu est %f \n",TEB);

% Rajout du bruit

figure(5);
for i = 1:length(Eb_N0_db)
    % Calcul de la puissance
    sigma2 = mean(abs(x).^2)*Ns/(2*log2(M)*10^(Eb_N0_db(i)/10));
    
    % Rajout du bruit
    b = sqrt(sigma2)*randn(1,length(x));
    r = x + b;
    
    % Retour en bande de base
    Signali_I = r.*cos(2*pi*fp*[1:length(xe)]*Te);
    Signali_Q = r.*sin(2*pi*fp*[1:length(xe)]*Te);
    
    % filtrage passe bas.
    xi1_filtre = filter(filtre_pass_bas,1,Signali_I);
    xi2_filtre = filter(filtre_pass_bas,1,Signali_Q);
    xi_filtre  = xi1_filtre -1i* xi2_filtre;
    
    % Passage parle filtre de réception.
    xi_r = filter(h_r,1,[xi_filtre zeros(1,span*Ns/2)]);
    xi_r = xi_r(span*Ns/2 +1:end);
    
    %Echantillonnage
    xi_ech = xi_r(1:Ns:end);
    
    %Demapping
    
    bits_recu = zeros(1,Nbits);
    symboles_ai_r = (sign(real(xi_ech))+1)/2;
    symboles_bi_r = (sign(imag(xi_ech))+1)/2; 
    bits_recu(1:2:end) = symboles_ai_r;
    bits_recu(2:2:end) = symboles_bi_r;
    
    % Le TEB
    nb_erreurs_i = length(find(bits ~= bits_recu));
    TEB(i) = nb_erreurs_i/length(bits);
    
end
semilogy(Eb_N0_db,TEB);
title("Taux d'erreur binaire obtenu avec bruit");
xlabel("Eb/N0 (en dB)");
ylabel("TEB");
grid on;

% Comparaison TEB simulé et TEB théorique.
figure(6);
TEB_th = qfunc(sqrt(2*10.^(Eb_N0_db/10)));
semilogy(Eb_N0_db,TEB)
hold on
semilogy(Eb_N0_db,TEB_th);
title("Comparaison entre TEB simulé et TEB théorique");
xlabel("Eb/N0 (en dB)");
ylabel("TEB");
legend("TEB simulé","TEB théorique");

% 3.2.2 - Implantation de la chaine passe-bas équivalente


% Affichage des signaux générés par les deux voix.
figure(7);
plot(xe_real);
axis([0 2000 -1 1])
title("Signal généré sur la voie en phase");

figure(8);
plot(xe_imag);
axis([0 2000 -1 1])
title("Signal généré sur la voie en quadrature");

% Traçage de la DSP et de l'envelope complexe.

x = xe;
figure(9);
DSP2_x = 1/length(x) * abs(fft(x,2^nextpow2(length(x)))).^2;
semilogy(linspace(-1/Ns,1/Ns,2^nextpow2(length(x))),fftshift(DSP2_x));
title("DSP de l'enveloppe complexe");
xlabel("Fréquences normalisées");
ylabel("Densité spectrale de puissance");

% Implantation de la chaine complète sans bruit.

% Passage par filtre de réception
x_r = filter(h_r,1,[x zeros(1,span*Ns/2)]);
x_r = x_r(span*Ns/2 +1:end);

% Echantillonnage
x_ech = x_r(1:Ns:end);

% Demapping
bits_dec = zeros(1,Nbits);
symboles_a_r = (sign(real(x_ech))+1)/2;
symboles_b_r = (sign(imag(x_ech))+1)/2; 
bits_dec(1:2:end) = symboles_a_r;
bits_dec(2:2:end) = symboles_b_r;

% TEB 
nb_erreurs = length(find(bits ~= bits_dec));
TEB2 = nb_erreurs/Nbits;
fprintf("(3.2) 3. Le TEB obtenu sans bruit est %f \n",TEB2)


% Rajout le bruit et traçage du TEB.
figure(10);
for i = 1:length(Eb_N0_db)
    sigma2 = mean(abs(x).^2)*Ns/(2*log2(M)*10^(Eb_N0_db(i)/10));
    
    % Rajout du bruit
    bruit_r = sqrt(sigma2)*randn(1,length(real(x)));
    bruit_i = sqrt(sigma2)*randn(1,length(imag(x)));
    bruit = bruit_r + 1i * bruit_i;
    r = x + bruit;
    
    % Passage par filtre de réception
    xi_rec = filter(h_r,1,[r zeros(1,span*Ns/2)]);
    xi_rec = xi_rec(span*Ns/2 +1:end);
    
    % Échantillonnage
    xi_ech = xi_rec(1:Ns:end);
    
    %Demapping
    bits_recu_i = zeros(1,Nbits);
    symboles_ai_r = (sign(real(xi_ech))+1)/2;
    symboles_bi_r = (sign(imag(xi_ech))+1)/2; 
    bits_recu_i(1:2:end) = symboles_ai_r;
    bits_recu_i(2:2:end) = symboles_bi_r;
    
    %Calcul du TEB
    nb_erreurs_i = length(find(bits ~= bits_recu_i));
    TEB_pb(i) = nb_erreurs_i/Nbits;
    
end
semilogy(Eb_N0_db,TEB_pb,'x-');
title("Taux d'erreur binaire avec bruit");
xlabel("Eb/N0 (en dB)");
ylabel("TEB");
grid on;


% Traçage des constellations en sortie du mapping et en sortie de
% l'échantillonneur pour valeur donnée de Eb/N0.
scatterplot(Symboles_d);
title("Les constellations en sortie du mapping");
%Pour une valeur de Eb/N0 égale à 6dB.
scatterplot(xi_ech);
title("Les constellations en sortie de l'échantillonneur");

figure(14);
semilogy(Eb_N0_db,TEB_pb,'x-');
hold on;
semilogy(Eb_N0_db,TEB,'v-');
title("Taux d'erreur binaire pour les deux chaines");
xlabel("Eb/N0 (en dB)");
ylabel("TEB");
legend("Chaine passe-bas équivalente","Chaine sur fréquence porteuse");
grid on;

