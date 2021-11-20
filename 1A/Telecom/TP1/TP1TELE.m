
Nbits = 1000;
Rb = 6000;
Fe = 24000;
Te = 1/Fe;
Nb = Fe/Rb;
M = 2;
Ns = log2(M)*Nb;
h = ones(1,Ns);
nfft = 2*nextpow2(Nbits*Ns);
N = 8;
Ts = Ns * Te;




% implantation du modulateur1ts
bits = randi(0:1,1,Nbits);
Symbole_1 = 2*bits -1;
a1 = kron(Symbole_1,[1 zeros(1,Ns-1)]);
%x génération du signal filtré 1
X_1 = filter(h,1,a1);
t1 = 0:Te:(length(X_1) - 1)*Te;
% tracé du signal X_1
figure;
plot(t1, X_1);
axis([0 0.02 -3.5 3.5]);
title("Signal produit par le modulateur 1");
xlabel("Temps en (s)");
ylabel("X_1");

% Tracage de DSP du signal transmit x1
figure;
DSPX1 = pwelch(X_1,[],[],[],Fe ,'twosided');
freq = linspace(-Fe/2, Fe/2,nfft);
semilogy(freq ,fftshift(abs(fft(X_1,nfft)).^2));
pwelch(X_1,[],[],[],Fe ,'twosided');



figure;
DSPth_X1 = Ts * sinc(pi*freq*Ts).^2;
frequence_1th = 0:Fe:(length(DSPth_X1) -1)*Fe
plot(frequence_1th,DSPth_X1);
title("densité spectral théorique DSPX1");



% implantation du modulteur2.

Ts = N * Te;
% mapping 4-aire
Symbole_2 = (2*bi2de(reshape(bits,2,length(bits)/2).') -3).';
a2 = kron(Symbole_2 ,[1 zeros(1,N -1)]);
%implantation du filtre de mise en forme modulateur 2
h_2 = ones(1,N);
figure;
% génération du signal filtré 2
X_2 = filter(h_2,1,a2);
t2 = 0:Te:(length(X_2) - 1)*Te;
%tracé du signal X_2
plot(t2,X_2);
axis([0 0.02 -3.5 3.5]);
title("Signal produit par le modulateur 2");
xlabel("Temps en (s)");
ylabel("X_2");
figure;
% tracé de la densité DSP_x2
DSP_x2 = pwelch(X_2,[],[],[],Fe ,'twosided');
frequence_2 = 0:Fe:(length(DSP_x2)-1)*Fe;
plot(frequence_2, DSP_x2,'b');
title("la densité spectrale de puissance du signal X_2");
xlabel("Fréquence en Hz");
ylabel("DSP_x2");

% tracé de la densité théorique DSPth_x2
figure;
DSPth_x2 =(1/Ts)*(abs(fft(X_2,Fe))).^2;
frequence_2th = 0:Fe:(length(DSPth_x2) - 1)*Fe;
plot(frequence_2th,DSPth_x2);
title("la densité spectrale de puissance théorique du signal X_2(t)");
xlabel("Fréquence en Hz");
ylabel("DSPth_x2");




% implantation du modulateur 3

h_3 = linspace(0,1,Ns);
X_3 = filter(h_3,1,a1);
t3 = 0:Te:(length(X_3) -1)*Te;
figure;
plot(t3,X_3);
axis([0 0.02 -3.5 3.5]);
xlabel("le temps en (s)");
ylabel("le signal modulé x3");
% Tracage de la densité spectral de puissance du signal x3
figure;
DSP_X3 = pwelch(X_3);
frequence_3 = 0:Fe:(length(DSP_X3)-1)*Fe;
plot(frequence_3, DSP_X3, 'r');
hold on;
title("la densité spectrale de puissance du signal X_3");
xlabel("frequence en HZ");
ylabel("DSP_X3(f)");
figure;
DSPth_X3 = Ts * (sin(pi*Ts*frequence_3).^2./(pi*frequence_3*Ts)).^2;
plot(frequence_3,DSPth_X3);
title("la densité spectrale de puissance theorique du signal X3");
xlabel("frequence en HZ");
ylabel("DSPth_X3(f)");




% Implantation du modulateur 4


alpha = 0.5;
span = 4;
Ns2 = 8;
h_4 = rcosdesign(alpha, span, Ns2);
Ns2 = 8;
Ts = Ns2 * Te;


figure;
X_4 = filter(h_4,1,a1);
t4 = 0:Te:(length(X_4) -1)*Te;
plot(t4,X_4);
axis([0 0.02 -3.5 3.5]);
xlabel("le temps en (s)");
ylabel("le signal modulé x4");
% Tracage de la densité spectral de puissance 
figure;
DSP_X4 = pwelch(X_4);
frequence_4 = 0:Fe:(length(DSP_X4)-1)*Fe;
plot(frequence_4, DSP_X4, 'g');
hold on;
title("la densité spectrale de puissance du signal X_4");
xlabel("frequence en HZ");
ylabel("DSP_X4");
frequence_4th = -(length(DSP_X4)-1)*Fe:Fe:(length(DSP_X4)-1)*Fe;
DSPth_X4 = ones(length(frequence_4th));
for i=1:length(frequence_4)
    if  -1/2 * 1/Ts *(1- alpha) < frequence_4th(i) < 1/2 * 1/Ts *(1- alpha)
        DSPth_X4 = 1;
    elseif     1/2 * 1/Ts *(1-alpha) < frequence_4th(i) < 1/2 * 1/Ts *(1 + alpha)
        DSPth_X4 = 1/2 * (1 + cos(1/alpha *pi*Ts*(frequence_4th(i) - 1/2 * 1/Ts * (1-alpha))));
    elseif   -1/2 * 1/Ts * (1 + alpha) < frequence_4th(i) < -1/2 * 1/Ts * (1-alpha)
        DSPth_X4 = 1/2 * (1 + cos(1/alpha *pi*Ts *(frequence_4th(i) - 1/2 * 1/Ts *(1-alpha))));
    else 
        DSPth_X4 = 0;
    end 
end
figure;
plot(frequence_4th,DSPth_X4);
title("la densité spectrale théorique DSPth_X4");
xlabel("frequence en HZ");
ylabel("DSPX4");





















