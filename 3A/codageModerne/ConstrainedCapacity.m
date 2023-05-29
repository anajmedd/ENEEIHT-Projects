% Simulation parameters
Ns= 100000;                  % Number of Symbols 
Es_N0_dB =  (-5:40);

%loop for order M
for M = [4 16 64 256 1024];                     % Constellation Order
Constellation=qammod((0:M-1)',M);
% Loop variable for SNR
% Monte carlo parameter
    
for snr=1:numel(Es_N0_dB)
    %generate M-QAM modulation
    
    s = randi([0 M-1],Ns,1);
    x = qammod(s, M);
    
    Es_N0=10^(Es_N0_dB(snr)/10);%normal
    sigx2=var(x);
    N0  = sigx2 /(Es_N0);
    
    %add noise
    noise_  = sqrt(N0/2 )*randn(length(x),1)+ ...
                1j*sqrt(N0/2 )*randn(length(x),1);
    sig_rx  =  x + noise_ ;
    
    %Compute Capacity
    %%Entropy
    Hx=log2(M);
    %%Conditionnal Entropy
    xref=repmat(Constellation,1,Ns);       %
    d2=-abs((repmat(sig_rx,1,M).'-xref)).^2/N0;
    PYX=exp(d2);
    PYx=exp(-abs((sig_rx-Constellation(s+1))).^2/N0);
    PxY=PYx./(sum(PYX)');
    HXY=-mean(log2(PxY'));
    ConstrainedCapacity(snr)=Hx-HXY;
end

plot(Es_N0_dB,ConstrainedCapacity)

hold on 

end

plot(Es_N0_dB,log2(1+10.^(Es_N0_dB/10)),'r-')
legend({'M=4','M=16','M=64','M=256','M=1024','Gaussian'},'Location','northwest')
xlabel('E_s/N_0 dB')
ylabel('Capacity in bpcu')
grid on