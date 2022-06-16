close all
clear all

N=8 ;  % Ns echantillons par chips
R=6 ;
L=(2^R-1);
M=L*N ; % L echantillons par bit cf enonce
N_symb=500; % nombre de symboles a generer
h=ones(1,N) ; % filtre rectangulaire de duree Tc

%
% generation coefficient du filtre PNF
%

% User1

init=ones(1,R);
connexions1=[2 5];
connexions2=[2 3 4 5];
nb_sequence =1 ; % 1 seule sequence pour PNF
chips1=PN1_ML(R,init,connexions1,nb_sequence);
chips2=PN1_ML(R,init,connexions2,nb_sequence); 
chips=xor(chips1,chips2);
chips=1-2*chips;
chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros
PNF_user1=filter(h,1,chips_inter); % filtrage => coeff de PNF

% User2

init__user2=[1,0,0,1,1,0,0,1,1,0];

chips1=PN1_ML(R,init,connexions1,nb_sequence);
chips2=PN1_ML(R,init__user2,connexions2,nb_sequence);
chips=xor(chips1,chips2);
chips=1-2*chips;
chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros
PNF_user2=filter(h,1,chips_inter); % filtrage => coeff de PNF

% User3

init__user3=[1,1,0,0,0,1,1,1,1,0];
chips1=PN1_ML(R,init,connexions1,nb_sequence);
chips2=PN1_ML(R,init__user3,connexions2,nb_sequence);
chips=xor(chips1,chips2);
chips=1-2*chips;
chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros
PNF_user3=filter(h,1,chips_inter); % filtrage => coeff de PNF

% User4
init__user4=[0,1,1,1,0,0,1,0,0,0];
chips1=PN1_ML(R,init,connexions1,nb_sequence);
chips2=PN1_ML(R,init__user4,connexions2,nb_sequence);
chips=xor(chips1,chips2);
chips=1-2*chips;
chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros
PNF_user4=filter(h,1,chips_inter); % filtrage => coeff de PNF

% User5

init__user5=[1,0,0,0,1,0,0,1,0,1];
nb_sequence =1 ; % 1 seule sequence pour PNF
chips1=PN1_ML(R,init,connexions1,nb_sequence);
chips2=PN1_ML(R,init__user5,connexions2,nb_sequence);
chips=xor(chips1,chips2);
chips=1-2*chips;
chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros
PNF_user5=filter(h,1,chips_inter); % filtrage => coeff de PNF



% Emetteur

% Modulation QPSK 
bits=randi([0 1],1,N_symb) ;
sym_qpsk=qammod(bits.',4,'InputType','bit').';
bits_inter_qpsk=kron(sym_qpsk,[1 zeros(1,M-1)]);% insertion 0
%bits_inter_qpsk=reshape([1;zeros(M-1,1)]*sym_qpsk,1,M*length(sym_qpsk)) ; % insertion 0


% User1
signal_emis_user1=conv(PNF_user1,bits_inter_qpsk,'full');

% User2 
signal_emis_user2=conv(PNF_user2,bits_inter_qpsk,'full');

% User3
signal_emis_user3=conv(PNF_user3,bits_inter_qpsk,'full');

% User4
signal_emis_user4=conv(PNF_user4,bits_inter_qpsk,'full');

% User5
signal_emis_user5=conv(PNF_user5,bits_inter_qpsk,'full');


% Signal total reçu 
signal_emis_qpsk=signal_emis_user1+signal_emis_user2+signal_emis_user3+signal_emis_user3+signal_emis_user4+signal_emis_user5;


% Recepteur

% User1
signal_recu_user1=filter(fliplr(PNF_user1),1,signal_emis_qpsk);
% User2
signal_recu_user2=filter(fliplr(PNF_user2),1,signal_emis_qpsk);
% User3 
signal_recu_user3=filter(fliplr(PNF_user3),1,signal_emis_qpsk);
% User4
signal_recu_user4=filter(fliplr(PNF_user4),1,signal_emis_qpsk);
% User5
signal_recu_user5=filter(fliplr(PNF_user5),1,signal_emis_qpsk);



% User1
signal_ech_qpsk1=signal_recu_user1(length(PNF_user1):M:end);
signal_demodule1=qamdemod(signal_ech_qpsk1.',4,'OutputType','bit').';

% User2
signal_ech_qpsk2=signal_recu_user2(length(PNF_user2):M:end);
signal_demodule2=qamdemod(signal_ech_qpsk2.',4,'OutputType','bit').';

% User3
signal_ech_qpsk3=signal_recu_user3(length(PNF_user3):M:end);
signal_demodule3=qamdemod(signal_ech_qpsk3.',4,'OutputType','bit').';

% User4
signal_ech_qpsk4=signal_recu_user4(length(PNF_user4):M:end);
signal_demodule4=qamdemod(signal_ech_qpsk4.',4,'OutputType','bit').';

% User5
signal_ech_qpsk5=signal_recu_user5(length(PNF_user5):M:end);
signal_demodule5=qamdemod(signal_ech_qpsk5.',4,'OutputType','bit').';

% Constellations pour les différents users
figure(1)
plot(real(signal_ech_qpsk1),imag(signal_ech_qpsk1),'*')
grid on
title("Constellations User 1")
figure(2)
plot(real(signal_ech_qpsk2),imag(signal_ech_qpsk2),'*')
grid on
title("Constellations User 2")
figure(3)
plot(real(signal_ech_qpsk3),imag(signal_ech_qpsk3),'*')
grid on
title("Constellations User 3")
figure(4)
plot(real(signal_ech_qpsk4),imag(signal_ech_qpsk4),'*')
grid on
title("Constellations User 4")
figure(5)
plot(real(signal_ech_qpsk5),imag(signal_ech_qpsk5),'*')
grid on
title("Constellations User 5")





% Cross-correlation des PNF 
figure(6)
[c,lags] = xcorr(PNF_user1,PNF_user2);
stem(lags,c)
title('Cross-correlation $R_{12}$','Interpreter', 'latex')
xlabel('$t/T_s$','Interpreter', 'latex')
figure(7)
[c,lags] = xcorr(PNF_user1,PNF_user1);
stem(lags,c)
title('Autocorrelation User 1','Interpreter', 'latex')
xlabel('$t/T_s$','Interpreter', 'latex')
