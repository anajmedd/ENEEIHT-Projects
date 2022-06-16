close all
clear all

% il faut avoir au prealable calculer la pente du detecteur en boucle
% ouverte

load pente_NDA_QPSK

d_phi_deg=input('dephasage en degre?');  % une seule valeur !
df_Rs=input('ecart de frequence / Rs= ?'); % une seule valeur !

BlT=input('Bande de bruit de la boucle?');  % ex: 0.01

ordre=input('ordre de la boucle (1 ou 2)?'); 

%
% calcul des parametres de la boucle
%

if ordre==2
zeta=sqrt(2)/2;
wnT=2*BlT./(zeta+1/(4*zeta));
A=wnT.*(2+wnT)./(1+3*wnT+wnT.^2);
B=wnT.^2./(1+3*wnT+wnT.^2);

elseif ordre==1
   B=0*BlT;
   A=4*BlT;
else
   display ('order1 assumed');
    B=0*BlT;
    A=4*BlT;
 end
 
 
EbNodB=input('Eb/No dB=?');
EbNo=10.^(EbNodB/10);

N_symb=1000;
M=4;   %QPSK
NCO_mem=0;      % initialisation du retard de la mise a jour
filtre_mem=0;   % initialisation de la memoire du filtre
phi_est(1)=0;  %  valeur initiale de la phase estimee

symb_emis=(2*randi([0 1],1,N_symb)-1)+j*(2*randi([0 1],1,N_symb)-1); % symboles QPSK
sigma = sqrt(1/(2*EbNo));   % sigma du bruit thermique
bruit=sigma*randn(1,N_symb)+j*sigma*randn(1,N_symb) ; % vecteur de bruit
dephasage=2*pi*df_Rs*[0:N_symb-1]+d_phi_deg*pi/180;  % dephasage signal recu
recu=symb_emis.*exp(j*dephasage)+bruit; % echantillons en entree DPLL

 %  DPLL
 
for ii=1:N_symb
    
     % affichage de ii par multiples de 1000
    if mod(ii,1000)==0
        ii
    end
   
    out_det(ii)= -imag(recu(ii)^4);% a completer ! %
    
    
    % filtre de boucle
    
    w(ii)=filtre_mem+out_det(ii); % memoire filtre + sortie detecteur 
    filtre_mem=w(ii);            
    out_filtre=A*out_det(ii)+B*w(ii);   % sortie du filtre a l'instant ii :  F(z)=A+B/(1-z^-1)
    
    % integrateur + retard 
    
    phi_est(ii+1)=(out_filtre+NCO_mem); % N(z)=1/(z-1) 
    NCO_mem=phi_est(ii+1);
    
    
end


figure(1)
plot(phi_est*180/pi)
grid on

xlabel('time')
ylabel('phi-est [degre]')

figure(2)
plot(out_det)
grid on
xlabel('time')
ylabel('detector output');

figure(3)
plot(B*w/(2*pi))
grid on
xlabel('time')
ylabel('frequency error');