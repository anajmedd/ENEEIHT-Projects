close all
clear all

Nbits = 1000;
Fe = 24000;
Te = 1/Fe;
Rb = 6000;
Fe = 24000;
fc = 400;
BW = 1000;
Nb = Fe/Rb;
M = 2;
Ns = 8;
h = ones(1,Ns);
Eb_N0_db = [0:8];


% 1. Introduction 

% Generatioon du mapping binaire
bits =randi(0:1,1,Nbits);
Symboles_1 = 2*bits -1;
a1 = kron(Symboles_1,[1 zeros(1,Ns-1)]);


% 2. Chaine de référence


% Modulation du signal x
x_mod = filter(h,1,a1);
% Filtre de reception 
hr_1 = ones(1,Ns);
% Demodulation du signal x
x_dem = filter(hr_1,1,x_mod);

% Choix de t0
t0 = Ns;
% Echantillonnage du signal transmis par la chaine 1
x_echantillonne1 = x_dem(t0:Ns:end);

% Calcul du TEB1
symb_dec = sign(x_echantillonne1);
bits_dec = (symb_dec+1)/2;
nb_erreurs1 = length(find(bits_dec ~= bits));
TEB1 = nb_erreurs1/length(bits);
fprintf("Le TEB obtenu est %f \n",TEB1);

% Rajout du bruit à la chaine de transmission
i=1;
while  i<=length(Eb_N0_db)
% Calcul de la puissance
sigma = mean(abs(x_mod).^2)*Ns/(2*log2(M)*10^(Eb_N0_db(i)/10));
bruit = sqrt(sigma)*randn(1,length(x_mod));
x_bruite = x_mod + bruit;

% Passage par le filtre de reception
x_dem_bruite = filter(hr_1,1,x_bruite);

% Calcul du TEB avec bruit
x_echantillonne_i = x_dem_bruite(t0:Ns:end);
symb_dec_bruite_i = sign(x_echantillonne_i);
bits_dec_bruite_i = (symb_dec_bruite_i+1)/2;
nb_erreurs_i = length(find(bits_dec_bruite_i ~= bits));
TEB(i) = nb_erreurs_i/length(bits);
i =i+1;
end

figure(1);
TEB_th = 1 - normcdf(sqrt(2*10.^(Eb_N0_db/10)));
semilogy(Eb_N0_db,TEB); hold on;
semilogy(Eb_N0_db,TEB_th,'r')
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")



% 3. Implantaion de la première chaine de transmission

% 3.2 Implantation sans bruit

hr_2 = linspace(0,1,Ns);
% Demodulation du signal x
x_dem2 = filter(hr_2,1,x_mod);
figure(2);
diagramme_oeil2 = reshape(x_dem2,Ns,length(x_dem2)/Ns);
plot(diagramme_oeil2);
title("Diagramme de l'oeil");

% Echantillonnage
x_echantillonne2 = x_dem2(t0:Ns:end);
% Décision 
symb_decide = sign(x_echantillonne2);
nb_erreurs2 = length(find(symb_decide ~= Symboles_1));
TEB2 = nb_erreurs2/length(bits);
fprintf("Le TEB obtenu est %f \n",TEB2);


% 3.3 Implantation avec bruit

while i<=length(Eb_N0_db)
% Calcul de la puissance
sigma = mean(x_mod.^2)*Ns/(2*log2(M)*10^(Eb_N0_db(i)/10));
bruit = sqrt(sigma)*randn(1,length(x_mod));
r = x_mod + bruit;

% Passage par le filtre de reception
x_dem_bruite2 = filter(hr_2,1,r);

% Calcul du TEB avec bruit
x_echantillonne2_i = x_dem_bruite2(t0:Ns:end);
symb_dec_bruite2_i = sign(x_echantillonne2_i);
bits_dec_bruite2_i = (symb_dec_bruite2_i+1)/2;
nb_erreurs2_i = length(find(bits_dec_bruite2_i ~= bits));
TEB(i) = nb_erreurs2_i/length(bits);
i=i+1;
end

figure(3);
TEB_th2 = 1 - normcdf(sqrt(2*10.^(Eb_N0_db/10)));
semilogy(Eb_N0_db,TEB); hold on;
semilogy(Eb_N0_db,TEB_th2,'r')
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")


% 4. Implantaion de la deuxième chaine de transmission


% Implantation sans bruit.

Symboles_2 = (2*bi2de(reshape(bits, 2,length(bits)/2).') -3).';
a2 = kron(Symboles_2,[1 zeros(1,Ns-1)]);
% Modulation du signal
x_mod3 = filter(h, 1, a2);
% Demodulation du signal
x_dem3 = filter(hr_1, 1, x_mod3);

% Diagramme de l'oeil en sortie du filtre de réception.
figure(4);
diag_oeil = reshape(x_dem3,2*Ns,length(x_mod3)/(2*Ns));
plot(diag_oeil)
title("Diagramme de l'oeil en sortie du filtre de réception")
xlabel("Temps en seconde")
ylabel("Diagramme de l'oeil")

% TEB Obtenu.
x_echantillonne3 = x_dem3(t0:Ns:end);
symboles_dec = zeros(1,length(x_echantillonne3));
for i=1 : length(x_echantillonne3)
    if (x_echantillonne3(i)>2*Ns)
        symboles_dec(i) = 3;
    elseif (0<=x_echantillonne3(i))
        symboles_dec(i) = 1;
    elseif (x_echantillonne3(i)<=-2*Ns)
        symboles_dec(i) = -3;
    else 
        symboles_dec(i) = -1;
    end
end
bits_dec3 = reshape(de2bi((symboles_dec+3)/2).',1,Nbits);
nb_erreurs3 = length(find(bits_dec3 ~= bits));
TEB3 = nb_erreurs3/Nbits;
fprintf("Le TEB obtenu est %f \n",TEB3);

% Implantation avec bruit.
i=1;
while i<=length(Eb_N0_db)
   % Calcul de la puissance
   sigma2 = mean(x_mod3.^2)*Ns/(4*10^(Eb_N0_db(i)/10));
   bruit2 = sqrt(sigma2)*randn(1,length(x_mod3));
   x_bruite2 = x_mod3 + bruit2;

   % Passage par le filtre de reception
   x_dem_bruite2 = filter(hr_1,1,x_bruite2);

   % Calcul du TEB avec bruit
   % Échantillonnage
   x_echantillonne2_i = x_dem_bruite2(t0:Ns:end);
   % Décision
   symboles_dec2_i = zeros(1,length(x_echantillonne2_i));
   for j=1:length(x_echantillonne2_i)
            if (2*Ns<x_echantillonne2_i(j))
                symboles_dec2_i(j) = 3;
            elseif (0<=x_echantillonne2_i(j) )
                symboles_dec2_i(j) = 1;
            elseif (x_echantillonne2_i(j) < -2*Ns)
                symboles_dec2_i(j) = -3;
            else
                symboles_dec2_i(j) = -1;
            end
        end
   bits_dec_bruite2_i = reshape(de2bi((symboles_dec2_i+3)/2).',1,Nbits);
   nb_erreurs4 = length(find(bits_dec_bruite2_i~= bits));
   TES4(i) = nb_erreurs4/Nbits;
   i=i+1;
   end

% TES en fonction de Eb/N0
figure(5);
semilogy(Eb_N0_db,TES4)
title("Taux d'erreur symbolique obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TES")

% Comparaison entre le TES théorique et le TES simulé
figure(6);hold on;
TES4_th = 3/2 * qfunc(sqrt(4/5*10.^(Eb_N0_db/10)));
semilogy(Eb_N0_db,TES4)
semilogy(Eb_N0_db,TES4_th,'g')
title("Comparaison entre le TES simulé et TES théorique")
legend("TES simulé","TES théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TES")


% Simulation du TEB.
figure(7);
TEB4 = TES4/2;
semilogy(Eb_N0_db,TEB4);
title("Taux d'erreur binaire obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

% Comparaison entre le TEB théorique et le TEB simulé
figure(8);hold on
TEB4_th = 3/4 * qfunc(sqrt(4/5 * 10.^(Eb_N0_db/10)));
semilogy(Eb_N0_db,TEB4);
semilogy(Eb_N0_db,TEB4_th);
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")


