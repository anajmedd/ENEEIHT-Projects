close all
clear all

N=8 ;  % Ns echantillons par chips
R=6 ;
L=(2^R-1);
M=L*N ; % L echantillons par bit cf enonce
N_symb=7000; % nombre de symboles a generer
TEB=[];
TEB_th=[];
%
% generation coefficient du filtre PNF
%

h=ones(1,N) ; % filtre rectangulaire de duree Tc
%h_rcos= rcosdesign(0.5,8,8);

init=ones(1,R);
connexions=[1 6];
nb_sequence =1 ; % 1 seule sequence pour PNF
chips=PN_ML(R,init,connexions,nb_sequence);
chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros
PNF=filter(h,1,chips_inter); % filtrage => coeff de PNF


% Emetteur


% Modulation QPSK 
bits=randi([0 1],1,N_symb) ;
symboles=qammod(bits.',4,'InputType','bit').';
bits_inter=kron(symboles,[1 zeros(1,M-1)]);% insertion 0

%bits_inter_qpsk=reshape([1;zeros(M-1,1)]*sym_qpsk,1,M*length(sym_qpsk)) ; % insertion 0


%signal_emis_qpsk=filter(PNF,1,bits_inter_qpsk);
signal_emis=conv(PNF,bits_inter,'full');



Eb_N0_dB=0:8 ;
Eb_N0=10.^(Eb_N0_dB/10);



for jj=1:length(Eb_N0_dB)

% % L'ajout du bruit blanc gaussien
 Puiss_sign = mean(abs(signal_emis) .^ 2);
 Puiss_bruit = Puiss_sign * M  / (2 * log2(4) * 10 .^ (Eb_N0_dB(jj) / 10));
 bruit_gauss = sqrt(Puiss_bruit) * randn(1, length(signal_emis)) + j * sqrt(Puiss_bruit) * randn(1, length(signal_emis));
 signal_emis_bruit = signal_emis+bruit_gauss ;


 % Filtrage de réception
 signal_apres_MF_qpsk=filter(fliplr(PNF),1,signal_emis_bruit);
 % Échantillonnge
 signal_apres_MF_ech_qpsk=signal_apres_MF_qpsk(length(PNF):M:end);
 % Demodulation
 bits_decide=qamdemod(signal_apres_MF_ech_qpsk.',4,'OutputType','bit').';
 
 a = length(find(bits_decide~= bits))/N_symb;
 TEB=[TEB a];



b=qfunc(sqrt(2*Eb_N0(jj)));
TEB_th=[TEB_th b];


end 

figure
plot(Eb_N0_dB,TEB)
hold on 
plot(Eb_N0_dB,TEB_th)
title('Figure 2 : Comparaison entre le TEB théorique et estimé');
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');
legend("TEB simulé","TEB théorique")


