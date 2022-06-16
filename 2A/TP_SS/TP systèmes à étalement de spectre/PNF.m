%
% programme utilisant la fontion PN_ML
%

clear all
close all

R=4 ; % nombre de registres = L=2^-1
L=2^R-1;
N=4; % nombre d'echantillons par chips
M=L*N; % nombre d'?chantillons par bit

init=ones(1,R); % initialisation des registres : tout sauf que des "0"

connexions=[1 4] ; % registres a connecter : valable pour 2 registres

nb_sequences=10;  % nombre de sequences desires en sortie


chips=PN_ML(R,init,connexions,nb_sequences) ;  

% filtrage rectangulaire, surechantillonnage de Ns


h=ones(1,N) ; %  coeff du filtre

chips_inter=reshape([1;zeros(N-1,1)]*chips,1,N*length(chips)) ; % insertion zeros

y=filter(h,1,chips_inter); % filtrage 

plot(y)
