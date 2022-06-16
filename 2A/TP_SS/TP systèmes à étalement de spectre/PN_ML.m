
% cette fonction genere nb_sequences de chips . 1 sequence = 2^R-1 chips
% init : valeurs initiales des registres
% R : nombre de registres
% connexions : connexions du XOR

function chips=PN_ML(R,init,connexions,nb_sequences)

RR=init; % initialisation des registres : tout sauf que des "0"

nb_ite=nb_sequences*(2^R-1);  % nombre de chips desires en sortie

for ii=1:nb_ite
    
    
    x_in=mod(RR(connexions(1))+RR(connexions(2)),2);  % entree instant ii (=sortie xor)
    x_out(ii)=RR(end);  % sortie instant ii
    
    RR(2:end) =RR(1:end-1); % decalage des registres = RR a l'instant ii+1
    RR(1)=x_in ;            % contenu 1er registre a l'instant ii+1          
end

chips=1-2*x_out ;  % mapping 0=1 et 1=-1

