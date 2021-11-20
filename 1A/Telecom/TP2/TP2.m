close all
clear all

Nbits = 1000;
Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Fe = 24000;
fc = 400;
BW = 1000;
Nb = Fe/Rb;
M = 2;
Ns = log2(M)*Nb;
N = 8;
alpha = 0.5;
span = 4;
h1 = ones(1,Ns);
h2 = rcosdesign(alpha, span, N);
t0 = N;
ordre =2;


% Partie 3.1

%------------------------------------------%
%----------------Question1-----------------%

% generatioon du mapping binaire
bits =randi(0:1,1,Nbits);
symbol = 2*bits -1;
a1 = kron(symbol,[1 zeros(1,Ns-1)]);
tab = [1 zeros(1,N-1)];

% implantation de la premiére chaine de transmission
% Modulation du signal x
x_mod = filter(h1,1,a1);
% Demodulation du signal x
x_dem = filter(h1,1,x_mod);


% implantation de la deuxiéme chaine de transmission
a2 = kron(symbol,tab);
% Modulation du signal
y_mod = filter(h2,1,[a2 zeros(1,span*N/2)]);
y_mod = y_mod(span*N/2 +1:end);
% Demodulation du signal
y_dem = filter(h2,1,y_mod);
%y_dem = y_dem(span*N/2 +1:end);

%------------------------------------------------%
%----------------Question2-----------------------%

% Traçage de la réponse impulsionnel globale de 
% la premiére chaine de transmission

figure;
z1 = conv(h1,h1);
plot(z1);
ylabel("reponse impulsionnel globale de la chaine 1");



% Traçage de la réponse impulsionnel globale de la deuxième 
% la deuxième chaine de transmission

figure;
z2 = conv(h2,h2);
plot(z2);
ylabel("reponse impulsionnel globale de la chaine2");

%-----------------------------------------------------%
%----------------Question4----------------------------%

% Diagramme de l'oeil du signal transmis par le canal 1
figure;
diagramme_oeil1 = reshape(x_dem,N,length(x_dem)/N);
plot(diagramme_oeil1);
title("Diagramme de l'oeil du signal transmis par la première chaine");


% Diagramme de l'oeil du signal transmis par le canal 1
figure;
diagramme_oeil2 = reshape(y_dem,2*N,length(y_dem)/(2*N));
plot(diagramme_oeil2);
title("Diagramme de l'oeil du signal transmis par la deuxième chaine");

%-------------Question5--------------------------------%
%------------------------------------------------------%
% à partir du diagramme de l'oeil on retrouve l'instant optimal
% de prelevement qui correspond à l'intersection des symboles qui 
% est N.


%------------------------------------------------------%
%-------------Question6--------------------------------%

% Echantillonnage du signal transmis par la chaine 1

x_echantillonne1 = x_dem(t0:N:end);

% Calcul du TEB1
symb_dec = sign(x_echantillonne1);
bits_dec = (symb_dec+1)/2;
nb_erreurs = length(find(bits_dec ~= bits));
TEB1 = nb_erreurs/length(bits);
fprintf("Le TEB obtenu est %f \n",TEB1);


% Echantillonnage du signal transmis par la chaine 2

x_echantillonne2 = y_dem(1:N:end);

% Calcul du TEB2
symb_dec2 = sign(x_echantillonne2);
bits_dec2 = (symb_dec2+1)/2;
nb_erreurs2 = length(find(bits_dec2 ~= bits));
TEB2 = nb_erreurs2/length(bits);
fprintf("Le TEB obtenu est %f \n",TEB2);

%----------------------------------------------------%
%------------Question7-------------------------------%

% Calcul du teb de la premiere chaine de transmission
% pour n0=3
sig_echau1 = x_dem(3:N:end);
sym_decide1 = sign(sig_echau1);
nbr_erreurs1 = length(find(sym_decide1 ~= symbol));
taux1 = nbr_erreurs1/length(symbol);
fprintf("Le Taux obtenu est %f \n",taux1);

% Calcul du teb de la deuxième chaine de transmission
% pour n0=6

sig_echau2 = x_dem(6:N:end);
sym_decide2 = sign(sig_echau2);
nbr_erreurs2 = length(find(sym_decide2 ~= symbol));
taux2 = nbr_erreurs2/length(symbol);
fprintf("Le Taux obtenu est %f \n",taux2);

% Partie 3.2
%--------------------------------------------------%
%-------------Question1----------------------------%

% Tracage de |H(f)Hr(f)| pour la chaine 1
figure(5);hold on
hc = (2 * fc/Fe)*sinc(2*fc*[-(ordre-1)*Te/2:Te:(ordre-1)*Te/2]);
reponse1 = abs(fft(h1)).^2;
frequence1 = 0:Fe:(length(reponse1)-1)*Fe;
plot(frequence1,reponse1,'r');

% Tracage de |Hc(f)| pour la chaine 1

reponse_hc = abs(fft(hc));
frequence2 = 0:Fe:(length(reponse_hc)-1)*Fe;
plot(frequence2,reponse_hc,'g');




% Tracage de |H(f)Hr(f)| pour BW=400
figure(6);hold on
hc1 = (2 * fc/Fe)*sinc(2*fc*[-(ordre-1)*Te/2:Te:(ordre-1)*Te/2]);
reponse1 = abs(fft(h1)).^2;
frequence1 = 0:Fe:(length(reponse1)-1)*Fe;
plot(frequence1,reponse1,'r');

% Tracage de |Hc(f)| 

reponse_hc1 = abs(fft(hc1));
frequence2 = 0:Fe:(length(reponse_hc1)-1)*Fe;
plot(frequence2,reponse_hc1,'g');



% Tracage de |H(f)Hr(f)| pour BW=1000
figure(6);hold on
hc2 = (2 * BW/Fe)*sinc(2*BW*[-(ordre-1)*Te/2:Te:(ordre-1)*Te/2]);
plot(frequence1,reponse1,'r');

% Tracage de |Hc(f)| 

reponse_hc2 = abs(fft(hc2));
frequence3 = 0:Fe:(length(reponse_hc2)-1)*Fe;
plot(frequence3,reponse_hc2,'g');

















