Fe = 24000;
Rb= 3000;
Tb = 1/Rb;
M=2;

bits = [1 1 1 0 0 1 0];
N = length(bits);

Ts = Tb;
Ns = Ts*Fe;
bits(bits == 0) = -1;

Bits_ns = zeros(length(bits),Ns);
Bits_ns(:,1)=reshape(bits,length(bits),1);
Bits_ns=reshape(Bits_ns',1,length(bits)*Ns);

%filtre de mise en forme
h = ones(1,Ns);

Xe = filter(h,1,Bits_ns);

%Signal de sortie sans canal
Ye = filter(h,1,Xe);



%2 - Calcul de TEB

t0 = Ns;

Ye_echantionne1 = Ye(t0:Ns:end);
Ye_echantionne1=sign(Ye_echantionne1);

Ye_echantionne1(Ye_echantionne1 == -1) = 0;
v1 = (bits ~= Ye_echantionne1);
TEB = sum(v1)/N;
fprintf("TEB : %d \n",TEB);
%On trouve TEB égale à 0

% 3 - Calcul de g = h*h_c*h_r

%g = h*h_r = h*h
g = conv(h,h);

%On a h_c = dirac(t) + dirac(t - Ts)/2
% Donc g = g(t) + (g(t - Ts))/2

%décalge de g d'une durée Ts g2 = (g(t - Ts))/2
g2 = 0.5.*[zeros(1,Ns) g];


%g = g(t) + (g(t - Ts))/2
%ajouter des zeros à la fin
g = [g zeros(1,Ns)];



g = g + g2;



% 3 - a) Signal à la sortie avec canal 

Ze = filter(g,1,Bits_ns);


figure(1);
plot(Ze);
title("Signal à la sortie avec canal");
%diagramme de l'oeil

diag_oeil = reshape(Ze,Ns,length(Ze)/Ns);
figure(2);
plot(diag_oeil);
title("diagramme de l'oeil");
% 3-b) Constellation

Ze_echantionne1 = Ze(t0:Ns:end);
Ze_echantionne1=sign(Ze_echantionne1);
figure(3);
plot(Ze_echantionne1,zeros(1,length(Ze_echantionne1)),"*");
axis([-2 2 -2 2]);
title("constellation BPSK");
grid on;

% 3-c) Calcul du TEB




Ze_echantionne1(Ze_echantionne1 == -1) = 0;
v1 = (bits ~= Ze_echantionne1);
TEB2 = sum(v1)/N;

fprintf("TEB2 : %d \n",TEB2);



% 4)
%Calcul de he
he = 0.5.*[zeros(1,Ns) h];
h2 = [h zeros(1,Ns)];
he = h2 + he;
x_mod = filter(he,1,Bits_ns);

%signal à la sortie du canal

Eb_N0_db = [0:10];
Nb = 5000;
s = zeros(1,10);
% Implantation avec bruit.

for i=1:length(Eb_N0_db)
   TEB = 0;
   for j=1:Nb
   % Calcul de la puissance
   sigma = mean(x_mod.^2)*Ns/(2*log2(M)*10^(Eb_N0_db(i)/10));
   bruit = sqrt(sigma)*randn(1,length(x_mod));
   x_bruite = x_mod + bruit;

   % Passage par le filtre de reception
   x_dem_bruite = filter(h,1,x_bruite);
   t0 = Ns;
   % Calcul du TEB avec bruit
   % Échantillonnage
   x_echantillonne_i = x_dem_bruite(t0:Ns:end);
   % Décision
   symboles_dec_i = sign(x_echantillonne_i);
   bits_dec = (symboles_dec_i+1)/2;
   nb_erreurs2 = length(find(bits_dec~= bits));
   TEB = TEB + nb_erreurs2/N;
   end
   TEB2(i)=TEB/Nb;
end
   
% TES en fonction de Eb/N0
figure(4);
semilogy(Eb_N0_db,TEB2)
title("Taux d'erreur binaire obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%TEB théorique sans canal multitrajet
TEB_th = qfunc(sqrt(2*10.^(Eb_N0_db)/10));
%TEB théorique Avec canal multitrajet
TEB_th_c = 0.5*qfunc(sqrt((2/5)*10.^(Eb_N0_db)/10)) + 0.5*qfunc(1.5*sqrt((8/5)*10.^(Eb_N0_db)/10));
figure(6);
semilogy(Eb_N0_db,TEB_th,'k-*');
hold on;
semilogy(Eb_N0_db,TEB_th_c,'r-o');
semilogy(Eb_N0_db,TEB2,'b-+');
xlabel("E_b/N_0");
ylabel("TEB");
legend("TEB théorique sans canal multitrajets","TEB théorique avec canal multitrajets","TEB simulé");
grid;





%Egalisation ZFE

%1) On a K = N


Z = Ze(t0:Ns:end);

Y0 = [1 zeros(1,Ns-2)]';

Z = toeplitz(Z);
C = Z\Y0;
%C = inv(Z)*Y0;

%2-ii)
%Sans bruit
figure(5);
%la réponse en fréquence de l’égaliseur
Cf = fftshift(C);
plot(Cf);


%2-iii) 
%Sans égalisation

Zs = Ze(t0:Ns:end);
subplot(1,2,1);
plot(Zs);
title("Sans égalisation");
%Avec égalisation

g_egalise = conv(g,C);
Ze_egalise = filter(g_egalise,1,Bits_ns);
Zs_egalise = Ze_egalise(t0:Ns:end);

subplot(1,2,2);
plot(Zs_egalise);
title("Avec égalisation");


