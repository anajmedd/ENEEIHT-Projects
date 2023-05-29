clear all
close all


N=12000;
Ns=8;
rolloff_emmission=0.35;
alpha =1;
Rs=1;
B=(1+alpha)*Rs;
fp = 2*Rs;
fe = 8*Rs;
Te = 1/fe;
span =8;

% Partie 1
% Génération des bits
bits=randi([0 1],N,1);
symboles = qammod(bits,4,'InputType','bit').';
suite_dirac = kron(symboles, [1 zeros(1, Ns - 1)]);

% Génération de la réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha,8,8);
signal_filtre= filter(h,1,suite_dirac);

[DSP_signal_emis,f] = pwelch(signal_filtre,[],[],[],Ns,'centered');
figure(1);
semilogy(f,DSP_signal_emis);
title('Densité Spectrale de Puissance du signal émis');
xlabel('Fréquence');

% Représentation signal sur la fréquence porteuse
n=0:length(signal_filtre)-1 ;
signal_porteuse = signal_filtre.*exp(1j *2*pi*0.25*n);
signal_porteuse = real(signal_porteuse);

% DSP du signal à la sortie du filtre d'interpolation :
[DSP_signal_porteuse,f] = pwelch(signal_porteuse,[],[],[],Ns,'centered');
figure(2);
semilogy(f,DSP_signal_porteuse);
title('DSP du signal en sortie de l interopllation ');
xlabel('Fréquence');


% Décalage en fréquence de -B
signal_decale = signal_porteuse.*exp(1j*2*pi*(B/fp)*n);
signal_decale = real(signal_decale);
[DSP_signal_decale,f] = pwelch(signal_decale,[],[],[],Ns,'centered');
figure(3);
semilogy(f,DSP_signal_decale);
title('Densité Spectrale de Puissance du signal aprés décalage Xn');
xlabel('Fréquence');


% Partie 2

signal_decale=signal_porteuse.*exp(-0.5*1j*pi*n);
[DSP,f] = pwelch(signal_decale,[],[],[],8,'centered');
figure(4);
semilogy(f,DSP)
title("DSP du signal après décalage '-B'")
xlabel('Fréquence');

h=rcosdesign(alpha,8,2,'normal');
signal_xe=filter(h,1,signal_decale);            
Yn=signal_xe(33+9:2:end);  

[DSP,f] = pwelch(Yn,[],[],[],8,'centered');
figure(5);
semilogy(f,DSP)
title("DSP du signal y(n)")
xlabel('Fréquence');


% Filtrage adapté
h=rcosdesign(alpha,4,2,'normal');
yn_r=filter(h,1,Yn);
yn_r_dec=yn_r(5:4:end);

% Constellations
scatterplot(yn_r_dec)

% Diagramme de l'oeil 
eyediagram(yn_r,4)

% Partie 3

% Génération des deux sous-suites de xn
xn_1=signal_porteuse(33:2:end);
xn_2=signal_porteuse(34:2:end);

% Génération des sous filtres
h = rcosdesign(alpha,8,2,'normal');
h_0=h(1:2:end);
h_1=[0 h(2:2:end)];

xn_1=xn_1.*kron(ones(1,length(xn_1)/2),[1 -1]);
xn_2=xn_2.*kron(ones(1,length(xn_2)/2),[1 -1]);

ReYn=filter(h_0,1,xn_1);
ImYn=(-1)*filter(h_1,1,xn_2);

% Signal Yn
Yn=ReYn(5:end)+1j*ImYn(5:end);

% DSP du signal Yn 

[DSP,f] = pwelch(Yn,[],[],[],8,'centered');
figure(8);
semilogy(f,DSP)
title("DSP du signal y(n)")

% Filtrage adapté
h= rcosdesign(alpha,4,2,'normal');
yn_r=filter(h,1,Yn);
yn_r_dec=yn_r(5:4:end);

% Constellations 
scatterplot(yn_r_dec)

% Diagramme de l'oeil 
eyediagram(yn_r,4)








