clear all 
close all



%%Partie II

%%2 - Etude de la diversité apportée par le codage dans un canal de Rayleigh non sélectif en
%%fréquence




%variables de la chaine de trasmission :
M=4;
alpha=0.5;
n0=8;
P=[1 1 0 1];
Eb_N0_dB=0:20;
Eb_N0=10.^(Eb_N0_dB/10);
Te=1;
span = 8;
Ts=4*Te;
Tc=10*Ts;
F=1/(5*Tc);
K=5;
Ns=4;
N=204;
K=188;
p = 8 * 100 * K;



% Génération de l’information binaire
bits_colone = randi([0 1],p,1);
bits = bits_colone.';

% Codage RS
enc = comm.RSEncoder(N,K,'BitInput',true);
dec = comm.RSDecoder(N,K,'BitInput',true);
bits_codes_RS=enc(bits_colone);


% L'entrelacement :
perm_vect = randperm(length(bits_codes_RS));
a = intrlv(bits_codes_RS,perm_vect);

% Generation du treillis
trellis = poly2trellis([7],[171 133]);
% Generation du code convolutif (Avec entrelaceur)
bits_codes_avec_e = convenc(a.',trellis,P).';

% Modulation BPSK
 
s_RS = qammod(bits_codes_avec_e,4,'InputType','bit').';
Suite_diracs = kron(s_RS, [1 zeros(1, Ns - 1)]);

% Génération de la réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha, 8, Ns, 'sqrt');
retard = (span * Ns) / 2;
% Filtrage de mise en forme du signal
x= filter(h,1,[Suite_diracs zeros(1,retard)]);
x= x(1 + retard : end);
    
   
% Canal de Rice 
canal_Rice= randn(1,length(x)) + j*randn(1,length(x));
[b,a] = butter(1,F);

m = filter(b,a,canal_Rice);
alpha1= sqrt(K*mean(m.^2));
w= m + alpha1;
yr = (m+alpha1).*x;

TEB1=zeros(1,21);
TEB2=zeros(1,21);

for j=0:20
   


     % L'ajout du bruit blanc gaussien

    Puiss_sign = mean(abs(x) .^ 2);
    Puiss_bruit=Puiss_sign *Ns / (2*log2(M) * 10 .^ (j / 10));
    Bruit_gauss = (sqrt(Puiss_bruit) * randn(1, length(yr))) + 1i * (sqrt(Puiss_bruit) * randn(1, length(yr)));
    y= yr + Bruit_gauss;

    % Egalisation :
    z_ml = y.*conj(w);

    % Filtrage de réception
    h_r = h;
    z = filter(h_r, 1, [z_ml zeros(1,retard)]);
    z = z(retard + 1 : end);

    
    % Echantillonage 
    z_echantillonne = z(1:Ns:end);
    % Demodulation
    bits_decide_souple= qamdemod(z_echantillonne,4,'OutputType','llr');
    v_bits_decide_souple = reshape(bits_decide_souple,1,2*length(bits_decide_souple));
    bits_decide_dur = qamdemod(z_echantillonne,4,'OutputType','bit');
    v_bits_decide_dur = reshape(bits_decide_dur,1,2*length(bits_decide_dur));



    % Decodage
    tb=5*7;
    % Hard decoding  
    bits_decodes_dur = vitdec(v_bits_decide_dur,trellis,tb,'trunc','hard',P);

    % Suppression de l'entrelacement
    bits_decodes_dur = deintrlv(bits_decodes_dur,perm_vect);

    % Décodage RS :
    bits_decodes_dur = dec(bits_decodes_dur.').';
    
    % TEB
	TEB1(j + 1) = length(find(bits_decodes_dur ~= bits)) / (length(bits));


    % Soft decoding :
   
    bits_decodes_souple = vitdec(v_bits_decide_souple,trellis,tb,'trunc','unquant',P);
    %dé_entrelacement
    bits_decodes_souple=deintrlv(bits_decodes_souple,perm_vect);
    %décodage RS :
    bits_decodes_souple=dec(bits_decodes_souple.');
    bits_decodes_souple=bits_decodes_souple.';
    % TEB
	TEB2(j + 1) = length(find(bits_decodes_souple ~= bits)) / (length(bits));

    
    

end

% Comparaison entre le taux d'erreur binaire (TEB) obtenu avec un codage
% soft et le TEB obtenu avec un codage hard
figure;
semilogy([0 : 20], TEB1, '-o');
hold on
semilogy([0 : 20], TEB2, 'k');
grid
title('TEB avec entrelacement dans le cas d une modulation QPSK');
legend('TEB avec codage Hard','TEB avec codage Soft')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');


% Diversités :
disp("diversité pour le décodage dur ")
P_soft=polyfit(Eb_N0_dB(3:14),10*log(TEB1(3:14)),1)
disp("diversité pour le décodage soft ")
P_hard=polyfit(Eb_N0_dB(3:14),10*log(TEB2(3:14)),1)


