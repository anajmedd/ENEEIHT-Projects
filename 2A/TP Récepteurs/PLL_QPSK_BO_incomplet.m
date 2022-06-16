
close all
clear all


d_phi_deg=input('plage erreur phase en degre?');  % definir un intervalle d'erreur de phase pour le detecteur    

EbNodB=input('Eb/No dB=?');  % fixer une seule valeur de Eb/NO
EbNo=10.^(EbNodB/10);

N_symb=1000;  % nombre de symboles envoyes

symb_emis=(2*randi([0 1],1,N_symb)-1)+1j*(2*randi([0 1],1,N_symb)-1); % symboles QPSK

sigma = sqrt(1/(2*EbNo));   % sigma du bruit thermique

bruit=sigma*randn(1,N_symb)+1j*sigma*randn(1,N_symb) ; % vecteur de bruit

for jj=1:length(d_phi_deg)  % boucle sur erreur de phase 
    
    % affichage phases
    if mod(jj,10)==0
        d_phi_deg(jj)
    end
            
    
    
       recu= symb_emis*exp(j*(pi/180)*d_phi_deg(jj)) + bruit;          %  signal recu :a completer 
        
        

       out_det= -imag(recu.^4);         % detecteur a completer
      
        
    
    S_curve(jj)=mean(out_det);

end

% on calcule la pente de la caracteristique (S-Curve) autour de 0 (entre -3 et 3 degres) : 

pente=S_curve((length(S_curve)+1)/2+3)-S_curve((length(S_curve)+1)/2-3);
pente=pente/(6*(d_phi_deg(2)-d_phi_deg(1))*pi/180);

figure(1)
plot(d_phi_deg,S_curve,'b-')
grid on
hold on
plot([-3:1:3],[-3:1:3]*pente*pi/180,'r-');

xlabel('erreur de phase')
ylabel('sortie du detecteur')

title('caracteristique (S-curve) du detecteur')

save pente_NDA_QPSK pente 

