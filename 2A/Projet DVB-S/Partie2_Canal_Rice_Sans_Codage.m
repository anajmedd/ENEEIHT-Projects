clear;
close all;
clc;



%%Partie II :

%%3- Etude de la diversité apportée par le codage dans un canal de Rice non sélectif en
%%fréquence


% Initialisation des paramètres
M=4;
Ns=4;
alpha=0.35;
n=10000;
span =8;
Eb_N0_dB=0:20;
Te=1;
Ts=4*Te;
Tc=10*Ts;
F=1/(5*Tc);
TEB = zeros(1,21);
K=[0 5 10];


% Génération de l'information binaire 
bits_colone=randi([0 1],n,1);
bits=bits_colone.';
% Mapping permettant d'obtenir dk ∈ {±1 ± j}
dk = qammod(bits_colone,4,'InputType','bit').';

% Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs = kron(dk, [1 zeros(1, Ns - 1)]);

% Génération de la réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha, 8, Ns, 'sqrt');
retard = (span * Ns) / 2;

signal_emis = filter(h,1,[Suite_diracs zeros(1,retard)]);
s = signal_emis(1+retard: length(signal_emis));
    
   

for ii = 1:3 

   % Canal de Rice 
   canal_rice = (randn(1,length(s))+ 1i * randn(1,length(s)));
   [b,a] = butter(1,F);
   m = filter(b,a,canal_rice);
   alpha_canal = sqrt(K(ii)*mean(m.^2));
   w = m+alpha_canal;
   c = (m+alpha_canal).*s;


for j = 0:20
   
    % L'ajout du bruit blanc gaussien
    Puiss_sign = mean(abs(s) .^ 2);
    Puiss_bruit = Puiss_sign*Ns/(2*log2(M)*10 .^ (j / 10));
    sigma=sqrt(Puiss_bruit);
    bruit = sigma*randn(1,length(c)) + 1i*sigma*randn(1,length(c)); 
    y = c + bruit;

    % Egalisation ML:
    y = y.*conj(m+alpha_canal);

    % Filtrage de réception
    hr = h;
    y = filter(hr, 1, [y zeros(1,retard)]);
    z = y(1 + retard:end);

    
    % Demodulation
    z_echantillonne = z(1:Ns:end);
    bits_decise_mat = qamdemod(z_echantillonne,4,'OutputType','bit');
    bits_decise = reshape(bits_decise_mat,1,2*length(bits_decise_mat));

   
    % Calcul du TEB
    TEB(j + 1) = length(find(bits_decise ~= bits)) / (length(bits));

end


plot(Eb_N0_dB,10*log(TEB),'-o')
hold on 
diversite = polyfit(Eb_N0_dB(3:14),10*log(TEB(3:14)),1);
fprintf("(2.3.2) La diversité obtenu pour k=%d est [%i %i] \n",ii,diversite);
end

legend("K=0dB","K=5dB","K=10dB")
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel("TEB")