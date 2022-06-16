close all
clear all

N=8 ;  % Ns echantillons par chips
R=6 ;
L=(2^R-1);
M=L*N ; % L echantillons par bit cf enonce
N_symb=50; % nombre de symboles a generer
alpha = 0.5; % roll_off
span = 4;
%
% generation coefficient du filtre PNF
%

h1=ones(1,N) ; % filtre rectangulaire de duree Tc
h2 = rcosdesign(alpha, span, N);
init=ones(1,R);

connexions=[1 6];

nb_sequence =1 ; % 1 seule sequence pour PNF

chips=PN_ML(R,init,connexions,nb_sequence);

chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros

PNF1=filter(h1,1,chips_inter); % filtrage => coeff de PNF
PNF2=filter(h2,1,chips_inter); % filtrage => coeff de PNF
%
% emetteur
%

bits=1-2*randi([0 1],1,N_symb);  % bits aleatoires
%bits=ones(1,N_symb);              % bits tous egaux a 1
%bits=[1 0]  ;              % reponse impulsionnelle
symboles = qammod(randi([0 1],1,N_symb).',4,'InputType','bit').';
symboles = kron(symboles, [1 zeros(1, M - 1)]);

bits_inter=reshape([1;zeros(M-1,1)]*bits,1,M*length(bits)) ; % insertion 0

%signal_emis=filter(PNF,1,bits_inter);
signal_emis=conv(PNF1,bits_inter,'full');

signal_emis2=conv(PNF1,symboles,'full');

[Pxx,F] = pwelch(signal_emis,[],512,1024,M,'twosided');

[Pxx2,F] = pwelch(signal_emis2,[],512,1024,M,'twosided');

figure
plot(F,10*log10(Pxx/max(Pxx)))
grid on
axis([0 M -40 5])
xlabel('f/Rs')
title('Densité spectrale de puissance du signal émis cas BPSK')

figure
plot(F,10*log10(Pxx2/max(Pxx2)))
grid on
axis([0 M -40 5])
xlabel('f/Rs')
title('Densité spectrale de puissance du signal émis cas QPSK')
%
% recepteur
%

signal_apres_MF1=filter(fliplr(PNF1),1,signal_emis);

figure

plot([0:length(signal_apres_MF1)-1]/M,signal_apres_MF1)

grid on

xlabel('t/Ts')
title('Signal reçu cas BPSK')

%
% recepteur (cas QPSK)
%

signal_apres_MF2=filter(fliplr(PNF1),1,signal_emis2);

figure

plot([0:length(signal_apres_MF2)-1]/M,signal_apres_MF2)

grid on

xlabel('t/Ts')
title('Signal reçu cas QPSK')

% réponse de filtre global (mise en forme rectangulaire)
figure
plot(conv(fliplr(PNF1),PNF1));
title("réponse du filtre global")
xlabel("Temps en s")
ylabel("PN_{f}(t)PN*_{f}(-t)")

% réponse de filtre global (lise en forme en racine carrée de cosinus surélevé)
figure
plot(conv(fliplr(PNF2),PNF2));
title("réponse du filtre global")
xlabel("Temps en s")
ylabel("PN_{f}(t)PN*_{f}(-t)")

%% Constellations BPSK

z_echant1 = signal_apres_MF1(1:M:end);
scatterplot(z_echant1);
title('Les constellations en sortie de l échantillonneur (BPSK)')
xlabel('I');
ylabel('Q');

% Constellations QPSK

z_echant2 = signal_apres_MF2(1:M:end);
scatterplot(z_echant2);
title('Les constellations en sortie de l échantillonneur (QPSK)')
xlabel('I');
ylabel('Q');









