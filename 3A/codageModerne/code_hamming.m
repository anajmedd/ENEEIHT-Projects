clear all
close all

% Hamming code parameters
H = [0 0 1 0 1 1 1; 0 1 0 1 0 1 1; 1 0 0 1 1 0 1];
P = H(:, 4:end);
N = length(H);
K = 4;
G = [P' eye(K)];

% Simulation parameters
Eb_N0_dB_tab = [-5:10];
TEB_ML_Hamming = [];
TEB_MAP_Hamming = [];
L = 10000; % Monte Carlo iterations

% Loop over different Eb/N0 values
for ii = 1:length(Eb_N0_dB_tab)
    err_ML = 0;
    err_MAP = 0;
    
    % Monte Carlo loop
    for jj = 1:L
        % Generate random bits
        u = randi([0 1], 1, K);
        c = rem(u*G, 2);
        x = 2*c - 1;
        
        % Add noise
        Es_N0_dB = Eb_N0_dB_tab(ii);
        Es_N0 = 10^(Es_N0_dB/10);
        sigx2 = var(x);
        noise = sqrt(sigx2 / (Es_N0)/2)*randn(1, length(x));
        y = x + noise;
        
        % Maximum likelihood decoding
        u_enum = de2bi((0:2^(K)-1)', 'left-msb');
        c_enum = rem(u_enum*G, 2);
        x_enum = 2*c_enum - 1;
        L_ch = (2/var(noise)) * y;
        c_est = x_enum * transpose(L_ch);
        [M, ind] = max(c_est);
        u_est = u_enum(ind, :);
        err_ML = err_ML + sum(u_est ~= u);
        
        % Maximum a posteriori decoding
        Nc = length(x_enum);
        yrep = repmat(y, Nc, 1);
        d2 = sum(abs((yrep - x_enum).^2), 2);
        pyc = exp(-d2 / (2*var(noise)));
        
        llr = log((1-c_enum)' * pyc) - log((c_enum)' * pyc);
        x_dec = -sign(llr);
        
        err_MAP = err_MAP + sum(x ~= x_dec');
    end
    
    % Compute TEB for each Eb/N0
    TEB_ML_Hamming = [TEB_ML_Hamming err_ML / (L * length(u))];
    TEB_MAP_Hamming = [TEB_MAP_Hamming err_MAP / (L * length(c))];
end

% Plot results
figure;
semilogy(Eb_N0_dB_tab, TEB_ML_Hamming)
hold on;
semilogy(Eb_N0_dB_tab, TEB_MAP_Hamming)
xlabel('E_b/N_0 [dB]')
ylabel('TEB')
legend('ML','MAP')
title('TEB en fonction du EbN0dB')
grid on;

