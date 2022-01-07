clc;
close all;
clear all
N= 16;
h = ones(1,N);
G = 5;
nombre_ofdm = 5000; % Nombre de symboles OFDM
Nbits = nombre_ofdm*N;
bits =randi(0:1,1,Nbits); % generation de la sequence de bits
sym = 2*bits -1;
M = reshape(sym,N,nombre_ofdm);
Hc = [0.227 0.46 0.688 0.46 0.227];

%  Erreur d'horloge

Hc=[Hc zeros(1,11)];
H=fft(Hc);
%%cas2: 

%emission
sortie1_ifft = ifft(M);
sortie1_ifft_pc = [sortie1_ifft(9:16,:); sortie1_ifft];
signal_emis = reshape(sortie1_ifft_pc,1,(8+N)*5000);

%canal
signal_recu1=filter(Hc,1,signal_emis );

%reception 
symboles_recu1 = signal_recu1;
entree1_fft = reshape(symboles_recu1,N+8,5000);
entree1_fft = entree1_fft(6:21,:);
sortie1_fft = fft(entree1_fft);

%Y=sortie_fft./H.';  (methode  ZF)
Y = sortie1_fft.*H'; %methode du maximum de vraisemblance
a = real(Y);
aa = sign(a);
symboles=[sortie1_fft(10,:)];


a=aa==M;
a=sum(sum(a));
TEB =1-a/(16*5000)
scatterplot(symboles)
title("Constellations obtenues en réception porteuse 10 cas 2")
%cas1

%emission
sortie_ifft=ifft(M);
sortie1_ifft_pc=[sortie_ifft(9:16,:); sortie1_ifft];
signal_emis =reshape(sortie1_ifft_pc,1,(8+N)*5000);

%canal
signal_recu=filter(Hc,1,signal_emis);

%reception 
symboles_recu = signal_recu;
mat_entre = reshape(symboles_recu,N+8,5000);
mat_entre = mat_entre(2:17,:);
sortie_fft = fft(mat_entre);

%Y=sortie_fft./H.';  (methode  ZF)
Y=sortie_fft.*H'; %methode du maximum de vraisemblance
a=real(Y);
aa=sign(a);
symboles=[sortie_fft(10,:)];

figure(2)
plot(real(symboles),imag(symboles),'*')
title("Constellations obtenues en réception Porteuse 10 cas 1")
a=aa==M;
a=sum(sum(a));
TEB = 1-a/(16*5000)

%cas3

%emission
M=reshape(sym,16,5000);
sortie_ifft=ifft(M);
sortie1_ifft_pc=[sortie_ifft(9:16,:); sortie_ifft];
signal_emis =reshape(sortie1_ifft_pc,1,(8+N)*5000);

%canal
signal_recu=filter(Hc,1,signal_emis);

%reception 
symboles_recu=signal_recu;
signal_recu=[signal_recu(2:end) signal_recu(1)];
mat_entre=reshape(symboles_recu,N+8,5000);
mat_entre=mat_entre(9:24,:);
sortie_fft=fft(mat_entre);


%Y=sortie_fft./H.';  (methode  ZF: zero forcing )
Y=sortie_fft.*H'; %methode ML: maximum de vraisemblance
a=real(Y);
aa=sign(a);
symboles=[sortie_fft(10,:)];

figure(3)
plot(real(symboles),imag(symboles),'*')
title("Constellations obtenues en réception Porteuse 10 cas 3")
a=aa==M;
a=sum(sum(a));
TEB =1-a/(16*5000)

figure(4)
plot(real(Y(10,:)),imag(Y(10,:)),'*')
title("Constellations obtenues en réception Porteuse avec egalisation ZF 10 cas 3")

% Estimation du canal dans le cas 1


Sym_pilote=sortie1_ifft(:,1);
Sysortie_fft=entree1_fft(:,1);
H_estime=Sysortie_fft./Sym_pilote;
%methode ML: maximum de vraisemblance
b=sortie1_fft.*conj(H_estime);
a=real(b);
aa=sign(a);
symboles=[b(10,:)];
scatterplot(symboles)
title("Constellations obtenues en réception")

